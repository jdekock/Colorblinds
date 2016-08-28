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
            
            image = processPixelsInImage(image)
            
            imageOverlay = UIImageView.init(frame: mainWindow.frame)
            imageOverlay.image = image
            mainWindow.addSubview(imageOverlay)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(ColorBlinds.updateScreen), userInfo: nil, repeats: true)
        } else {
            resetColors()
        }
    }
    
    func updateScreen() {
        imageOverlay.alpha = 0
        UIGraphicsBeginImageContextWithOptions(mainWindow.frame.size, false, 0.0)
        mainWindow.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageOverlay.alpha = 1
        
        image = processPixelsInImage(image)
        imageOverlay.image = image
    }
    
    func resetColors() {
        timer.invalidate()
        timer = nil
        imageOverlay.removeFromSuperview()
    }
    
    func processPixelsInImage(inputImage: UIImage) -> UIImage {
        let inputCGImage     = inputImage.CGImage
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = CGImageGetWidth(inputCGImage)
        let height           = CGImageGetHeight(inputCGImage)
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = CGImageAlphaInfo.PremultipliedFirst.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue
        
        let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)!
        CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), inputCGImage)
        
        let pixelBuffer = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(context))
        
        var currentPixel = pixelBuffer
        
        for var i = 0; i < Int(height); i++ {
            for var j = 0; j < Int(width); j++ {
                let pixel = currentPixel.memory
                
                //Protanopia:{ R:[56.667, 43.333, 0], G:[55.833, 44.167, 0], B:[0, 24.167, 75.833]},
                let pred: Float = Float(red(pixel))
                let pblue: Float = Float(blue(pixel))
                let pgreen: Float = Float(green(pixel))
                
                let npred = (pred * 0.56) + (pgreen * 0.43) + (pblue * 0)
                let npgreen = (pred * 0.55) + (pgreen * 0.45) + (pblue * 0)
                let npblue = (pred * 0) + (pgreen * 0.24) + (pblue * 0.75)
                
                currentPixel.memory = rgba(red: UInt8(npred), green: UInt8(npgreen), blue: UInt8(npblue), alpha: alpha(pixel))
                
                currentPixel += 1
            }
        }
        
        let outputCGImage = CGBitmapContextCreateImage(context)
        let outputImage = UIImage(CGImage: outputCGImage!, scale: inputImage.scale, orientation: inputImage.imageOrientation)
        
        return outputImage
    }
    
    func alpha(color: UInt32) -> UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
    func red(color: UInt32) -> UInt8 {
        return UInt8((color >> 16) & 255)
    }
    
    func green(color: UInt32) -> UInt8 {
        return UInt8((color >> 8) & 255)
    }
    
    func blue(color: UInt32) -> UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    func rgba(red red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
        return (UInt32(alpha) << 24) | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
    }
}
