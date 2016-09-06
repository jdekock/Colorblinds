//
//  ColorBlindController.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 28-08-16.
//  Copyright © 2016 Jordi de Kock. All rights reserved.
//

import UIKit

class ColorBlinds: NSObject, UIActionSheetDelegate {
    var screenshot: UIImage!
    var imageOverlay: UIImageView!
    var timer: NSTimer!
    var mainWindow: UIWindow!
    var colorMode: ColorBlindType!
    
    override init() {
        super.init()
    }
    
    static let sharedInstance = ColorBlinds()
    
    func startForWindow(window: UIWindow) {
        mainWindow = window
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(ColorBlinds.startColorBlinds))
        tapGesture.numberOfTapsRequired = 3
        mainWindow.userInteractionEnabled = true
        mainWindow.addGestureRecognizer(tapGesture)
    }
    
    func startColorBlinds() {
        if timer != nil {
            imageOverlay.removeFromSuperview()
            timer.invalidate()
            timer = nil
        }
        
        let actionSheet = UIAlertController(title: "Choose type of color blindness", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Deuteranomaly", style: .Default, handler: { (action) in
            self.colorMode = .Deuteranomaly
            self.setColor()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Deuteranopia", style: .Default, handler: { (action) in
            self.colorMode = .Deuteranopia
            self.setColor()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Protanomaly", style: .Default, handler: { (action) in
            self.colorMode = .Protanomaly
            self.setColor()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Protanopia", style: .Default, handler: { (action) in
            self.colorMode = .Protanopia
            self.setColor()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Stop colorblind mode", style: .Destructive, handler: { (action) in
            self.stopColorblinds()
        }))
        
        mainWindow.rootViewController?.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func setColor() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        UIGraphicsBeginImageContextWithOptions((mainWindow?.frame.size)!, false, 0.0)
        mainWindow.drawViewHierarchyInRect((mainWindow?.frame)!, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image = CBPixelHelper.processPixelsInImage(image, type: self.colorMode)
        
        imageOverlay = UIImageView.init(frame: mainWindow.frame)
        imageOverlay.image = image
        mainWindow.addSubview(imageOverlay)
            
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ColorBlinds.updateScreen), userInfo: nil, repeats: true)
    }
    
    func stopColorblinds() {
        //done
    }
    
    func updateScreen() {
        self.imageOverlay.removeFromSuperview()
        UIGraphicsBeginImageContextWithOptions(self.mainWindow.frame.size, false, 0.0)
        self.mainWindow.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        mainWindow.addSubview(imageOverlay)
        
        //Check if screen changed
        var screenshotData = NSData()
        if self.screenshot != nil {
            screenshotData = UIImagePNGRepresentation(self.screenshot)!;
            print("got screenshot data")
        }
        
        let imageData = UIImagePNGRepresentation(image);
        
        if screenshotData != imageData {
            print("replace image overlay with new image")
            self.screenshot = image
            
            image = CBPixelHelper.processPixelsInImage(image, type: self.colorMode)
            
            self.imageOverlay.image = image
        }
    }
    
    // MARK: UIActionSheetDelegate
    
}
