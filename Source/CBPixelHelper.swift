//
//  CBPixelHelper.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 29-08-16.
//  Copyright © 2016 Jordi de Kock. All rights reserved.
//

import UIKit

class CBPixelHelper: NSObject {
    class func processPixelsInImage(_ inputImage: UIImage, type: ColorBlindType) -> UIImage {
        let inputCGImage     = inputImage.cgImage
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage?.width
        let height           = inputCGImage?.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width!
        let bitmapInfo       = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)!
        context.draw(inputCGImage!, in: CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!)))
        
        let pixelBuffer = UnsafeMutableRawPointer(context.data)
        let opaquePtr = OpaquePointer(pixelBuffer)
        let contextBuffer = UnsafeMutablePointer<UInt32>(opaquePtr)
        let currentPixel = contextBuffer
        
        var count = 0
        
        for _ in 0..<Int(height!) {
            for _ in 0..<Int(width!) {
                let pixel = currentPixel![count]
                
                let pred: Float = Float(red(pixel))
                let pblue: Float = Float(blue(pixel))
                let pgreen: Float = Float(green(pixel))
                
                let colors = CBColorBlindTypes.getColorModified(type, red:pred, green:pgreen, blue:pblue)
                currentPixel![count] = rgba(red: UInt8(colors[0]), green: UInt8(colors[1]), blue: UInt8(colors[2]), alpha: alpha(pixel))
                
                count += 1
            }
        }
        
        let outputCGImage = context.makeImage()
        let outputImage = UIImage(cgImage: outputCGImage!, scale: inputImage.scale, orientation: inputImage.imageOrientation)
        
        return outputImage
    }
    
    class func alpha(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
    class func red(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 16) & 255)
    }
    
    class func green(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 8) & 255)
    }
    
    class func blue(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    class func rgba(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
        return (UInt32(alpha) << 24) | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
    }
}
