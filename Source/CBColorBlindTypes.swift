//
//  CBColorBlindTypes.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 29-08-16.
//  Copyright © 2016 Jordi de Kock. All rights reserved.
//

import Foundation

enum ColorBlindType : Int {
    case Deuteranomaly = 1
    case Deuteranopia = 2
    case Protanomaly = 3
    case Protanopia = 4
}

class CBColorBlindTypes: NSObject {
    class func getColorModified(type: ColorBlindType, red: Float, green: Float, blue: Float) -> Array<Float> {
        switch type {
        case .Deuteranomaly:
            return [(red*0.80)+(green*0.20)+(blue*0),
                    (red*0.25833)+(green*0.74167)+(blue*0),
                    (red*0)+(green*0.14167)+(blue*0.85833)]
        case .Protanopia:
            return [(red*0.56667)+(green*0.43333)+(blue*0),
                    (red*0.55833)+(green*0.44167)+(blue*0),
                    (red*0)+(green*0.24167)+(blue*0.75833)]
        case .Deuteranopia:
            return [(red*0.625)+(green*0.375)+(blue*0),
                    (red*0.7)+(green*0.3)+(blue*0),
                    (red*0)+(green*0.3)+(blue*0.7)]
        case .Protanomaly:
            return [(red*0.81667)+(green*0.18333)+(blue*0.0),
                    (red*0.33333)+(green*0.66667)+(blue*0.0),
                    (red*0.0)+(green*0.125)+(blue*0.875)]
        }
        
    }
}