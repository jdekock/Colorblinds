//
//  CBColorBlindTypes.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 29-08-16.
//  Copyright © 2016 Jordi de Kock. All rights reserved.
//

import Foundation

/**
 Type of color blindness.
 
 - Deuteranomaly: Malfunctioning M-cone (green).
 - Deuteranopia: Missing. M-cone (green).
 - Protanomaly: Malfunctioning L-cone (red).
 - Protanopia: Missing L-cone (red).
 */
enum ColorBlindType : Int {
    case deuteranomaly = 1
    case deuteranopia = 2
    case protanomaly = 3
    case protanopia = 4
    case tritanopia = 5
}

class CBColorBlindTypes: NSObject {
    class func getColorModified(_ type: ColorBlindType, red: Float, green: Float, blue: Float) -> Array<Float> {
        switch type {
        case .deuteranomaly:
            return [(red*0.80)+(green*0.20)+(blue*0),
                    (red*0.25833)+(green*0.74167)+(blue*0),
                    (red*0)+(green*0.14167)+(blue*0.85833)]
        case .protanopia:
            return [(red*0.56667)+(green*0.43333)+(blue*0),
                    (red*0.55833)+(green*0.44167)+(blue*0),
                    (red*0)+(green*0.24167)+(blue*0.75833)]
        case .deuteranopia:
            return [(red*0.625)+(green*0.375)+(blue*0),
                    (red*0.7)+(green*0.3)+(blue*0),
                    (red*0)+(green*0.3)+(blue*0.7)]
        case .protanomaly:
            return [(red*0.81667)+(green*0.18333)+(blue*0.0),
                    (red*0.33333)+(green*0.66667)+(blue*0.0),
                    (red*0.0)+(green*0.125)+(blue*0.875)]
        }
    }
        
    }
}
