//
//  MeshComponent.swift
//  AsteroidGame
//
//  Created by Cris on 8/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import SpriteKit
import GameplayKit

class MeshComponent: GKComponent {
    
    var node: SCNNode?
    var scene: SCNScene?
    
    init(modelPath: String, modelRootName: String) {
        super.init()
        self.scene = SCNScene(named: modelPath)
        self.node = loadModel(modelPath: modelPath, with: modelRootName)
        self.node?.name = modelRootName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadModel(modelPath: String, with name: String) -> SCNNode? {
        return (scene?.rootNode.childNode(withName: name, recursively: false))
    }
}
