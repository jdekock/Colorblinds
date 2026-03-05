import UIKit
import MetalKit
import CoreImage

// MARK: - PassThroughWindow

/// A UIWindow that passes touches through to the window below when
/// the hit lands on the root view controller's view itself (not a subview).
private class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hit = super.hitTest(point, with: event) else { return nil }
        // If the hit view is the root view, pass through
        if hit === rootViewController?.view {
            return nil
        }
        return hit
    }
}

// MARK: - ColorBlindOverlay

/// Singleton overlay that captures the source window's content and renders it
/// through a `CIColorMatrix` filter on a Metal-backed `MTKView`.
@MainActor
public final class ColorBlindOverlay: NSObject {
    public static let shared = ColorBlindOverlay()

    private var sourceWindow: UIWindow?
    private var overlayWindow: PassThroughWindow?
    private var mtkView: MTKView?
    private var displayLink: CADisplayLink?

    private var currentType: ColorBlindType?

    // Metal pipeline
    private let device: MTLDevice?
    private let commandQueue: MTLCommandQueue?
    private let ciContext: CIContext?

    private var tapGesture: UITapGestureRecognizer?

    private override init() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeCommandQueue()
        if let device {
            ciContext = CIContext(
                mtlDevice: device,
                options: [.cacheIntermediates: false]
            )
        } else {
            ciContext = nil
        }
        super.init()
    }

    // MARK: - Public API

    /// Starts the full color blindness simulator experience: triple-tap gesture
    /// on the source window opens a picker, and the selected filter is applied
    /// as an overlay.
    public func start(in window: UIWindow) {
        sourceWindow = window
        installTapGesture(on: window)
    }

    /// Directly applies a color blindness simulation overlay.
    public func simulate(_ type: ColorBlindType, in window: UIWindow) {
        sourceWindow = window
        currentType = type
        setupOverlayIfNeeded()
        startDisplayLink()
    }

    /// Stops the simulation and removes the overlay.
    public func stop() {
        stopDisplayLink()
        removeOverlay()
        removeTapGesture()
        currentType = nil
        sourceWindow = nil
    }

    // MARK: - Tap Gesture

    private func installTapGesture(on window: UIWindow) {
        removeTapGesture()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap))
        gesture.numberOfTapsRequired = 3
        window.addGestureRecognizer(gesture)
        tapGesture = gesture
    }

    private func removeTapGesture() {
        if let gesture = tapGesture {
            gesture.view?.removeGestureRecognizer(gesture)
            tapGesture = nil
        }
    }

    @objc private func handleTripleTap() {
        showPicker()
    }

    // MARK: - Picker

    private func showPicker() {
        guard let sourceWindow,
              let rootVC = sourceWindow.rootViewController?.presentedViewController
                ?? sourceWindow.rootViewController else { return }

        let alert = UIAlertController(
            title: "Color Blind Simulator",
            message: "Select a type of color blindness to simulate.",
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(title: "Normal Vision", style: .default) { [weak self] _ in
            self?.currentType = nil
            self?.stopDisplayLink()
            self?.removeOverlay()
        })

        for type in ColorBlindType.allCases {
            let checkmark = type == currentType ? " \u{2713}" : ""
            alert.addAction(UIAlertAction(
                title: "\(type.displayName)\(checkmark)",
                style: .default
            ) { [weak self] _ in
                guard let self else { return }
                self.currentType = type
                self.setupOverlayIfNeeded()
                self.startDisplayLink()
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // iPad popover anchor
        if let popover = alert.popoverPresentationController {
            popover.sourceView = rootVC.view
            popover.sourceRect = CGRect(
                x: rootVC.view.bounds.midX,
                y: rootVC.view.bounds.midY,
                width: 0, height: 0
            )
            popover.permittedArrowDirections = []
        }

        rootVC.present(alert, animated: true)
    }

    // MARK: - Overlay Window

    private func setupOverlayIfNeeded() {
        guard overlayWindow == nil, let sourceWindow else { return }
        guard let device else { return }

        let overlay = PassThroughWindow(windowScene: sourceWindow.windowScene!)
        overlay.windowLevel = .statusBar + 1
        overlay.backgroundColor = .clear
        overlay.isUserInteractionEnabled = false

        let metalView = MTKView(frame: sourceWindow.bounds, device: device)
        metalView.isPaused = true
        metalView.enableSetNeedsDisplay = false
        metalView.framebufferOnly = false
        metalView.isOpaque = false
        metalView.backgroundColor = .clear
        metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        metalView.contentScaleFactor = sourceWindow.screen.scale

        let vc = UIViewController()
        vc.view.addSubview(metalView)
        overlay.rootViewController = vc
        overlay.makeKeyAndVisible()

        // Return key status to the source window
        sourceWindow.makeKey()

        overlayWindow = overlay
        mtkView = metalView
    }

    private func removeOverlay() {
        mtkView?.removeFromSuperview()
        mtkView = nil
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }

    // MARK: - Display Link

    private func startDisplayLink() {
        guard displayLink == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(renderFrame))
        link.preferredFrameRateRange = CAFrameRateRange(
            minimum: 15, maximum: 60, preferred: 30
        )
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    // MARK: - Rendering

    @objc private func renderFrame() {
        guard let currentType,
              let sourceWindow,
              let mtkView,
              let commandQueue,
              let ciContext,
              let drawable = mtkView.currentDrawable else { return }

        let scale = sourceWindow.screen.scale
        let size = sourceWindow.bounds.size
        let pixelSize = CGSize(width: size.width * scale, height: size.height * scale)

        // Capture the source window's content
        let renderer = UIGraphicsImageRenderer(size: size)
        let snapshot = renderer.image { ctx in
            sourceWindow.layer.render(in: ctx.cgContext)
        }
        guard let cgImage = snapshot.cgImage else { return }

        // Build CIImage and apply CIColorMatrix
        let inputImage = CIImage(cgImage: cgImage)
        let vectors = currentType.ciVectors

        guard let filter = CIFilter(name: "CIColorMatrix") else { return }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(vectors.rVector, forKey: "inputRVector")
        filter.setValue(vectors.gVector, forKey: "inputGVector")
        filter.setValue(vectors.bVector, forKey: "inputBVector")
        filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 1), forKey: "inputAVector")
        filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBiasVector")

        guard let outputImage = filter.outputImage else { return }

        // Render to the Metal drawable
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }

        let destination = CIRenderDestination(
            width: Int(pixelSize.width),
            height: Int(pixelSize.height),
            pixelFormat: mtkView.colorPixelFormat,
            commandBuffer: commandBuffer,
            mtlTextureProvider: { drawable.texture }
        )

        do {
            try ciContext.startTask(toRender: outputImage, to: destination)
        } catch {
            return
        }

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
