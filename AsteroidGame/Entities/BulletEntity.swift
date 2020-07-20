//
//  BulletEntity.swift
//  AsteroidGame
//
//  Created by Cris on 19/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import SceneKit
import GameplayKit

class BulletEntity: GKEntity {
    
    struct Constants {
        static let modelPath = "art.scnassets/Bullet.scn"
        static let modelRootName = "Bullet"
    }
    
    override init() {
        super.init()
        
        let meshComponent = MeshComponent(modelPath: Constants.modelPath, modelRootName: Constants.modelRootName)
        addComponent(meshComponent)
        
        let collisionComponent = CollisionComponent(categoryBitMask: GamePhysicsBodyType.bullet.rawValue,
                                                    contactTestBitMask: GamePhysicsBodyType.asteroid.rawValue,
                                                    phycisBodyType: .static,
                                                    node: meshComponent.node)
        addComponent(collisionComponent)
    }
    
    
    func startPoint(spaceship: SCNNode?) {
        guard let node = component(ofType: MeshComponent.self)?.node,
            let spawnBulletPoint = spaceship?.childNode(withName: "Bullet", recursively: false) else { return }
        node.position = spawnBulletPoint.worldPosition
        startAnimationMove()
    }
    
    func startAnimationMove() {
        let move = SCNAction.repeatForever(SCNAction.move(by: SCNVector3(0.0, 0.0, -1), duration: 1))
        component(ofType: MeshComponent.self)?.node?.runAction(move)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
