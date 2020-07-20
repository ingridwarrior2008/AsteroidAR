//
//  SpaceshipEntity.swift
//  AsteroidGame
//
//  Created by Cris on 8/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import Foundation

import SceneKit
import GameplayKit

class SpaceshipEntity: GKEntity {
    
    struct Constants {
        static let modelPath = "art.scnassets/SpaceShip.dae"
        static let modelRootName = "SpaceShip"
    }
    
    var bulletSpawnPoint: SCNNode?
    
    override init() {
        super.init()
        
        let meshComponent = MeshComponent(modelPath: Constants.modelPath, modelRootName: Constants.modelRootName)
        addComponent(meshComponent)
        
        let collisionComponent = CollisionComponent(categoryBitMask: GamePhysicsBodyType.spaceShip.rawValue,
                                                    contactTestBitMask: GamePhysicsBodyType.asteroid.rawValue,
                                                    phycisBodyType: .static,
                                                    node: meshComponent.node)
        addComponent(collisionComponent)
        
//        if let scene = meshComponent.scene {
//            bulletSpawnPoint = scene.rootNode.childNode(withName: "Bullet", recursively: false)
//            meshComponent.node?.addChildNode(bulletSpawnPoint!)
//        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
