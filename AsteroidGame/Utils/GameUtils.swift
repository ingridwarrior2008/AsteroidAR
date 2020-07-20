//
//  GameUtils.swift
//  AsteroidGame
//
//  Created by Cris on 19/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import Foundation

class GameUtils {
    static func randomRange(_ first: Float, and second: Float) -> Float {
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    static func deg2rad(_ number: Float) -> Float {
        return number * .pi / 180.0
    }
}
