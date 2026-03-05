import UIKit
import SwiftUI
import Colorblinds

final class UIKitExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
        ])

        // Color swatches
        let swatchColors: [(String, UIColor)] = [
            ("Red", .systemRed),
            ("Green", .systemGreen),
            ("Blue", .systemBlue),
            ("Yellow", .systemYellow),
            ("Orange", .systemOrange),
            ("Purple", .systemPurple),
            ("Pink", .systemPink),
            ("Teal", .systemTeal),
            ("Brown", .systemBrown),
            ("Indigo", .systemIndigo),
        ]

        // Build rows of 3
        for rowStart in stride(from: 0, to: swatchColors.count, by: 3) {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually

            for i in rowStart..<min(rowStart + 3, swatchColors.count) {
                let (name, color) = swatchColors[i]
                let swatch = makeSwatchView(name: name, color: color)
                rowStack.addArrangedSubview(swatch)
            }

            // Pad incomplete rows
            let remaining = 3 - (min(rowStart + 3, swatchColors.count) - rowStart)
            for _ in 0..<remaining {
                let spacer = UIView()
                rowStack.addArrangedSubview(spacer)
            }

            contentStack.addArrangedSubview(rowStack)
            rowStack.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }

        // Gradient bar
        let gradientView = GradientBarView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gradientView.layer.cornerRadius = 10
        gradientView.clipsToBounds = true
        contentStack.addArrangedSubview(gradientView)

        // Spacer
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 16).isActive = true
        contentStack.addArrangedSubview(spacer)

        // Buttons
        let startButton = makeButton(title: "Start Simulator", color: .systemBlue, action: #selector(startSimulator))
        let simulateButton = makeButton(title: "Simulate Deuteranopia", color: .systemOrange, action: #selector(simulateDirect))
        let stopButton = makeButton(title: "Stop", color: .systemRed, action: #selector(stopSimulator))

        contentStack.addArrangedSubview(startButton)
        contentStack.addArrangedSubview(simulateButton)
        contentStack.addArrangedSubview(stopButton)
    }

    private func makeSwatchView(name: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = color
        container.layer.cornerRadius = 12

        let label = UILabel()
        label.text = name
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        return container
    }

    private func makeButton(title: String, color: UIColor, action: Selector) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = color
        config.cornerStyle = .medium
        let button = UIButton(configuration: config)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }

    @objc private func startSimulator() {
        guard let window = view.window else { return }
        ColorBlindOverlay.shared.start(in: window)
    }

    @objc private func simulateDirect() {
        guard let window = view.window else { return }
        ColorBlindOverlay.shared.simulate(.deuteranopia, in: window)
    }

    @objc private func stopSimulator() {
        ColorBlindOverlay.shared.stop()
    }
}

// MARK: - Gradient Bar

private final class GradientBarView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemOrange.cgColor,
            UIColor.systemYellow.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

// MARK: - SwiftUI Wrapper

struct UIKitExampleWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let vc = UIKitExampleViewController()
        vc.title = "UIKit"
        return UINavigationController(rootViewController: vc)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
