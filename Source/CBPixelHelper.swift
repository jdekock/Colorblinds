//
//  CBPixelHelper.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 29-08-16.
//  Copyright © 2016 Jordi de Kock. All rights reserved.
//

import UIKit

class CBPixelHelper: NSObject {
    class func processPixelsInImage(inputImage: UIImage, type: ColorBlindType) -> UIImage {
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
        
        for _ in 0..<Int(height) {
            for _ in 0..<Int(width) {
                let pixel = currentPixel.memory
                
                let pred: Float = Float(red(pixel))
                let pblue: Float = Float(blue(pixel))
                let pgreen: Float = Float(green(pixel))
                
                let colors = CBColorBlindTypes.getColorModified(type, red:pred, green:pgreen, blue:pblue)
                currentPixel.memory = rgba(red: UInt8(colors[0]), green: UInt8(colors[1]), blue: UInt8(colors[2]), alpha: alpha(pixel))
                
                currentPixel += 1
            }
        }
        
        let outputCGImage = CGBitmapContextCreateImage(context)
        let outputImage = UIImage(CGImage: outputCGImage!, scale: inputImage.scale, orientation: inputImage.imageOrientation)
        
        return outputImage
    }
    
    class func alpha(color: UInt32) -> UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
    class func red(color: UInt32) -> UInt8 {
        return UInt8((color >> 16) & 255)
    }
    
    class func green(color: UInt32) -> UInt8 {
        return UInt8((color >> 8) & 255)
    }
    
    class func blue(color: UInt32) -> UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    class func rgba(red red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
        return (UInt32(alpha) << 24) | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
    }
}
