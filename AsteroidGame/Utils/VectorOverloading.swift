//
//  VectorOverloading.swift
//  AsteroidGame
//
//  Created by Cris on 19/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import SceneKit

func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

func / (lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    return SCNVector3Make(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
}

extension SCNVector3 {
    func length() -> Float {
         return sqrt(x*x + y*y + z*z)
     }
    
    func normalized() -> SCNVector3 {
        if self.length() == 0 {
            return self
        }
        return self / self.length()
    }
}

