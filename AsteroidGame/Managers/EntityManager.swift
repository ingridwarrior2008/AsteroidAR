//
//  EntityManager.swift
//  AsteroidGame
//
//  Created by Cris on 19/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import SceneKit
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    let scene: SCNScene
    
    init(scene: SCNScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        scene.spawn(entity: entity)
    }
    
    func delete(_ entity: GKEntity) {
        entities.remove(entity)
        scene.delete(entity: entity)
    }
    
    func findEntity(from node: SCNNode) -> GKEntity? {
       return entities.first { $0.component(ofType: MeshComponent.self)?.node == node }
    }
    
    func update(_ deltaTime: TimeInterval) {
        entities.forEach { (entity) in
            entity.update(deltaTime: deltaTime)
        }
    }
}
