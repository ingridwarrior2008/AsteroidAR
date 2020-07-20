//
//  SceneExtensions.swift
//  AsteroidGame
//
//  Created by Cris on 9/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import SceneKit
import GameplayKit

extension SCNScene {
    
    func spawn(entity: GKEntity) {
        guard let entityClass = entity.component(ofType: MeshComponent.self)?.node else {
            return
            
        }
        rootNode.addChildNode(entityClass)
    }
    
    func delete(entity: GKEntity) {
        guard let entityClass = entity.component(ofType: MeshComponent.self)?.node else { return }
        entityClass.removeFromParentNode()
    }
}
