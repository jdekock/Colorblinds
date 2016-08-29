//
//  ColorBlindController.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 28-08-16.
//  Copyright © 2016 Label A. All rights reserved.
//

import UIKit

class ColorBlinds: NSObject {
    var imageOverlay: UIImageView!
    var timer: NSTimer!
    var mainWindow: UIWindow!
    
    override init() {
        super.init()
    }
    
    func start() {
        mainWindow = UIApplication.sharedApplication().keyWindow
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(ColorBlinds.startColorBlinds))
        tapGesture.numberOfTapsRequired = 3
        mainWindow.userInteractionEnabled = true
        mainWindow.addGestureRecognizer(tapGesture)
    }
    
    func startColorBlinds() {
        if timer == nil {
            UIGraphicsBeginImageContextWithOptions((mainWindow?.frame.size)!, false, 0.0)
            mainWindow.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            var image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            image = CBPixelHelper.processPixelsInImage(image, type: .Protanopia)
            
            imageOverlay = UIImageView.init(frame: mainWindow.frame)
            imageOverlay.image = image
            mainWindow.addSubview(imageOverlay)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(ColorBlinds.updateScreen), userInfo: nil, repeats: true)
        } else {
            stopColorblinds()
        }
    }
    
    func stopColorblinds() {
        timer.invalidate()
        timer = nil
        imageOverlay.removeFromSuperview()
    }
    
    func updateScreen() {
        imageOverlay.alpha = 0
        UIGraphicsBeginImageContextWithOptions(mainWindow.frame.size, false, 0.0)
        mainWindow.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageOverlay.alpha = 1
        
        image = CBPixelHelper.processPixelsInImage(image, type: .Protanopia)
        imageOverlay.image = image
    }
}
