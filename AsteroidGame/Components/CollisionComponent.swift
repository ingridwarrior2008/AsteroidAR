//
//  CollisionComponent.swift
//  AsteroidGame
//
//  Created by Cris on 9/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import Foundation

import SpriteKit
import GameplayKit

class CollisionComponent: GKComponent {
    
    var physicsBody: SCNPhysicsBody
    
    init(categoryBitMask: Int, contactTestBitMask: Int, phycisBodyType: SCNPhysicsBodyType, node: SCNNode? = nil) {
        let physicsShape = SCNPhysicsShape(node: node ?? SCNNode())
        physicsBody = SCNPhysicsBody(type: phycisBodyType, shape: physicsShape)
        physicsBody.categoryBitMask = categoryBitMask
        physicsBody.contactTestBitMask = contactTestBitMask
        physicsBody.restitution = 1
        node?.physicsBody = physicsBody
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
