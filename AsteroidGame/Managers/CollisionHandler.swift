//
//  CollisionHandler.swift
//  AsteroidGame
//
//  Created by Cris on 19/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

protocol CollisionDelegate: class {
    func didBulletColideAsteroid()
    func didAsteroidColideSpaceship()
}

class CollisionHandler {
    let entityManager: EntityManager?
    weak var delegate: CollisionDelegate?
    
    init(entityManager: EntityManager?) {
        self.entityManager = entityManager
    }
    
    func didStartCollision(contact: SCNPhysicsContact) {
        if contact.nodeA.name == SpaceshipEntity.Constants.modelRootName,
            contact.nodeB.name == AsteroidEntity.Constants.modelRootName {
            if let asteroid = entityManager?.findEntity(from: contact.nodeB) {
                entityManager?.delete(asteroid)
                delegate?.didAsteroidColideSpaceship()
            }
        } else if contact.nodeA.name == AsteroidEntity.Constants.modelRootName,
            contact.nodeB.name == SpaceshipEntity.Constants.modelRootName {
            if let asteroid = entityManager?.findEntity(from: contact.nodeA) {
                entityManager?.delete(asteroid)
                delegate?.didAsteroidColideSpaceship()
            }
        }
        
        if contact.nodeA.name == BulletEntity.Constants.modelRootName,
            contact.nodeB.name == AsteroidEntity.Constants.modelRootName {
            if let asteroid = entityManager?.findEntity(from: contact.nodeB),
                let bullet = entityManager?.findEntity(from: contact.nodeA) {
                entityManager?.delete(asteroid)
                entityManager?.delete(bullet)
                delegate?.didBulletColideAsteroid()
            }
        } else if contact.nodeA.name == AsteroidEntity.Constants.modelRootName,
            contact.nodeB.name == BulletEntity.Constants.modelRootName {
            if let asteroid = entityManager?.findEntity(from: contact.nodeA),
                let bullet = entityManager?.findEntity(from: contact.nodeB) {
                entityManager?.delete(asteroid)
                entityManager?.delete(bullet)
                delegate?.didBulletColideAsteroid()
            }
        }
    }
}
