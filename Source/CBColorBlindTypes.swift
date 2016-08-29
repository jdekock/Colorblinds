//
//  CBColorBlindTypes.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 29-08-16.
//  Copyright © 2016 Label A. All rights reserved.
//

import Foundation

enum ColorBlindType : Int {
    case Protanopia = 1
    case Protonamaly = 2
}

class CBColorBlindTypes: NSObject {
    class func getColorModified(type: ColorBlindType, red: Float, green: Float, blue: Float) -> Array<Float> {
        switch type {
        case .Protanopia:
            return [(red*0.56667)+(green*0.43333)+(blue*0),
                    (red*0.55833)+(green*0.44167)+(blue*0),
                    (red*0)+(green*0.24167)+(blue*0.75833)]
        default:
            return [(red*0.56667)+(green*0.43333)+(blue*0),
                    (red*0.55833)+(green*0.44167)+(blue*0),
                    (red*0)+(green*0.24167)+(blue*0.75833)]
        }
        
    }
}