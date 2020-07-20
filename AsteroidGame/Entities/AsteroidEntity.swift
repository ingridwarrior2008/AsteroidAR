//
//  AsteroidEntity.swift
//  AsteroidGame
//
//  Created by Cris on 19/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import SceneKit
import GameplayKit

class AsteroidEntity: GKEntity {
    
    struct Constants {
        static let modelPath = "art.scnassets/Rock.scn"
        static let modelRootName = "Rock"
        static let limitTime: TimeInterval = 1.0
        static let movingVelocity: Float = 10
        static let minRange: Float = -0.5
        static let maxRange: Float = 0.5
        static let spawnDistance: Float = 1.0
        static let endDistance: Float = 2.0
    }
    
    var endPoint = SCNVector3(0.0, 0.0, 0.0)
    var movingTime: TimeInterval = 0.0
    
    override init() {
        super.init()
        
        let meshComponent = MeshComponent(modelPath: Constants.modelPath, modelRootName: Constants.modelRootName)
        addComponent(meshComponent)
        
        let collisionComponent = CollisionComponent(categoryBitMask: GamePhysicsBodyType.asteroid.rawValue,
                                                    contactTestBitMask: GamePhysicsBodyType.spaceShip.rawValue,
                                                    phycisBodyType: .static,
                                                    node: meshComponent.node)
        addComponent(collisionComponent)
    }
    
    
    func startPoint(spaceshipPosition: SCNVector3) {
        guard let node = component(ofType: MeshComponent.self)?.node else { return }
        
        let posX = GameUtils.randomRange(Constants.minRange, and: Constants.maxRange)
        
        node.position = SCNVector3(posX,
                                   spaceshipPosition.y,
                                   spaceshipPosition.z - Constants.spawnDistance)
        
        endPoint = SCNVector3(posX,
                              spaceshipPosition.y,
                              spaceshipPosition.z - Constants.endDistance)
        
        startAnimationMove()
    }
    
    func startAnimationMove() {
        let rotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 10, duration: 10))
        let move = SCNAction.repeatForever(SCNAction.move(by: SCNVector3(0.0, 0.0, 1), duration: 2))
        let group = SCNAction.group([rotation, move])
        
        component(ofType: MeshComponent.self)?.node?.runAction(group)
    }

    private func move(deltaTime: TimeInterval) {
        guard let node = component(ofType: MeshComponent.self)?.node else { return }
        let currentPoint = node.position
        let direction = (endPoint - currentPoint).normalized()
        
        let velocity = direction * Float(deltaTime.second) * Constants.movingVelocity
        let newPosition = velocity + node.position
        node.position = newPosition
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //TODO: move(deltaTime: seconds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimeInterval {
    
    var second: Double {
        return truncatingRemainder(dividingBy: 60)
    }
}
