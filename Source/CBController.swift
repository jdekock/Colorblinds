//
//  ColorBlindController.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 28-08-16.
//  Copyright © 2016 Jordi de Kock. All rights reserved.
//

import UIKit

open class CBController: NSObject, UIActionSheetDelegate {
    var screenshot: UIImage!
    var imageOverlay: UIImageView!
    var timer: Timer!
    var mainWindow: UIWindow!
    var colorMode: ColorBlindType!
    
    override init() {
        super.init()
    }
    
    /**
     Colorblinds can be easily activated through the sharedinstance. This makes it easy to start and stop a single instance of Colorblinds.
     */
    public static let sharedInstance = CBController()
    
    /**
     Call this method to initiate Colorblinds on your window. Colorblinds only supports one window at the moment.
     
     - parameter window: The window on which you would like to add the action and colorblind mode
     */
    open func startForWindow(_ window: UIWindow) {
        mainWindow = window
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(CBController.startColorBlinds))
        tapGesture.numberOfTapsRequired = 3
        mainWindow.isUserInteractionEnabled = true
        mainWindow.addGestureRecognizer(tapGesture)
    }
    
    @objc func startColorBlinds() {
        if timer != nil {
            imageOverlay.removeFromSuperview()
            timer.invalidate()
            timer = nil
        }
        
        let actionSheet = UIAlertController(title: "Choose type of color blindness", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Deuteranomaly", style: .default, handler: { (action) in
            self.colorMode = .deuteranomaly
            self.setColor()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Deuteranopia", style: .default, handler: { (action) in
            self.colorMode = .deuteranopia
            self.setColor()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Protanomaly", style: .default, handler: { (action) in
            self.colorMode = .protanomaly
            self.setColor()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Protanopia", style: .default, handler: { (action) in
            self.colorMode = .protanopia
            self.setColor()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Stop colorblind mode", style: .destructive, handler: { (action) in
            self.stopColorblinds()
        }))
        
        var topController = mainWindow.rootViewController
        
        if topController!.presentedViewController != nil {
            topController = topController!.presentedViewController;
        }
        
        topController!.present(actionSheet, animated: true, completion: nil)
    }
    
    func setColor() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        UIGraphicsBeginImageContextWithOptions((mainWindow?.frame.size)!, false, 0.0)
        mainWindow.drawHierarchy(in: (mainWindow?.frame)!, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image = CBPixelHelper.processPixelsInImage(image!, type: self.colorMode)
        
        imageOverlay = UIImageView.init(frame: mainWindow.frame)
        imageOverlay.image = image
        mainWindow.addSubview(imageOverlay)
            
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CBController.updateScreen), userInfo: nil, repeats: true)
    }
    
    func stopColorblinds() {
        //done
    }
    
    @objc func updateScreen() {
        self.imageOverlay.removeFromSuperview()
        UIGraphicsBeginImageContextWithOptions(self.mainWindow.frame.size, false, 0.0)
        self.mainWindow.layer.render(in: UIGraphicsGetCurrentContext()!)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        mainWindow.addSubview(imageOverlay)
        
        //Check if screen changed
        var screenshotData = Data()
        if self.screenshot != nil {
            screenshotData = self.screenshot.pngData()!;
            print("got screenshot data")
        }
        
        let imageData = image!.pngData();
        
        if screenshotData != imageData {
            print("replace image overlay with new image")
            self.screenshot = image
            
            image = CBPixelHelper.processPixelsInImage(image!, type: self.colorMode)
            
            self.imageOverlay.image = image
        }
    }
    
    // MARK: UIActionSheetDelegate
    
}
