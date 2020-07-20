//
//  GameViewController.swift
//  AsteroidGame
//
//  Created by Cris on 7/07/20.
//  Copyright © 2020 Ingrid Guerrero. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum GamePhysicsBodyType: Int {
    case spaceShip = 1
    case asteroid = 2
    case bullet = 3
}

class GameViewController: UIViewController {
    
    // MARK: - Constants -
    
    private struct Constants {
        static let companyLogo = "CompanyLogo"
        static let reSpawnDuration: TimeInterval = 1
        static let moveSpaceshipDuration: TimeInterval = 0.5
        static let defaultSpacehispRotation: Float = GameUtils.deg2rad(180.0)
        static let spaceshipRotationOnMove: Float = 45.0
        static let asteroidScore = 10
    }
    
    // MARK: - IBOutlet -
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var findLogoLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var readyLabel: UILabel!
    
    // MARK: - Properties -
    
    var mainNode: SCNNode?
    var spaceShipEntity: SpaceshipEntity?
    var timer: Timer?
    var entityManager: EntityManager?
    var collisionHandler: CollisionHandler?
    var isShipLoaded = false
    var score = 0
    
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupARKitSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: - IBActions methods -

extension GameViewController {
    
    
    @IBAction func didTapMoveLeft(_ sender: Any) {
        guard let spaceshipNode = self.spaceShipEntity?.component(ofType: MeshComponent.self)?.node else { return }
        moveSpaceship(spaceshipNode: spaceshipNode,
                      direction: SCNVector3(-0.1, 0, 0),
                      rotationValue: Constants.spaceshipRotationOnMove)
    }
    
    @IBAction func didTapMoveRight(_ sender: Any) {
        guard let spaceshipNode = self.spaceShipEntity?.component(ofType: MeshComponent.self)?.node else { return }
        moveSpaceship(spaceshipNode: spaceshipNode,
                      direction: SCNVector3(0.1, 0, 0),
                      rotationValue: -Constants.spaceshipRotationOnMove)
    }
    
    @IBAction func didTapFire(_ sender: Any) {
        guard let spaceshipNode = self.spaceShipEntity?.component(ofType: MeshComponent.self)?.node else { return }
        let bullet = BulletEntity()
        entityManager?.add(bullet)
        bullet.startPoint(spaceship: spaceshipNode)
        bullet.destroyAfter(entity: entityManager)
    }
}

// MARK: - Private methods -

private extension GameViewController {
    
    func setupARKitSession() {
        
        guard let triggerImages = ARReferenceImage.referenceImages(inGroupNamed: Constants.companyLogo, bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = triggerImages
        configuration.maximumNumberOfTrackedImages = 0
        configuration.isLightEstimationEnabled = false
        
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.session.run(configuration)
    }
    
    func setup() {
        setupARKitSession()
        
        entityManager = EntityManager(scene: sceneView.scene)
        collisionHandler = CollisionHandler(entityManager: entityManager)
        collisionHandler?.delegate = self
        spaceShipEntity = SpaceshipEntity()
        showFindLabel(true)
    }
    
    func showFindLabel(_ enable: Bool) {
        findLogoLabel.isHidden = !enable
        scoreLabel.isHidden = enable
        buttons.forEach { $0.isHidden = enable}
    }
    
    func createSpaceshipSpawnNode(for anchor: ARImageAnchor) -> SCNNode {
        
        let plane = SCNBox(width: anchor.referenceImage.physicalSize.width,
                           height: 0.0001, length: anchor.referenceImage.physicalSize.height,
                           chamferRadius: 0)
        
        if let material = plane.firstMaterial {
            material.diffuse.contents = UIColor.red
            material.transparency = 0.0
        }
        
        return SCNNode(geometry: plane)
    }
    
    @objc func startSpawnAsteroid() {
        DispatchQueue.main.async {
            guard let spaceshipPosition = self.spaceShipEntity?.component(ofType: MeshComponent.self)?.node?.position else { return }
            let asteroidEntity = AsteroidEntity()
            
            self.entityManager?.add(asteroidEntity)
            asteroidEntity.startPoint(spaceshipPosition: spaceshipPosition)
            
            asteroidEntity.destroyAfter(entity: self.entityManager)
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.reSpawnDuration),
                                     target: self,
                                     selector: #selector(startSpawnAsteroid),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func moveSpaceship(spaceshipNode: SCNNode, direction: SCNVector3, rotationValue: Float) {
        let move = SCNAction.move(by: direction, duration: Constants.moveSpaceshipDuration)
        spaceshipNode.eulerAngles = SCNVector3(0.0, Constants.defaultSpacehispRotation, rotationValue)
        spaceshipNode.runAction(move) {
            spaceshipNode.eulerAngles = SCNVector3(0.0, Constants.defaultSpacehispRotation, 0.0)
        }
    }
}

// MARK: - ARSCNViewDelegate -

extension GameViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let imageAnchor = anchor as? ARImageAnchor {
            mainNode = createSpaceshipSpawnNode(for: imageAnchor)
            mainNode?.position = SCNVector3()
            return mainNode
        }
        return nil
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARImageAnchor, let node = mainNode else { return }
        
        if let spaceShip = spaceShipEntity,
            let meshNode = spaceShip.component(ofType: MeshComponent.self)?.node,
            !isShipLoaded {
            
            meshNode.position = node.position
            entityManager?.add(spaceShip)
            isShipLoaded = true
            startTimer()
            
            DispatchQueue.main.async {
                self.showFindLabel(false)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        entityManager?.update(time)
    }
}

// MARK: - SCNPhysicsContactDelegate -

extension GameViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        collisionHandler?.didStartCollision(contact: contact)
    }
}

// MARK: - CollisionDelegate -

extension GameViewController: CollisionDelegate {
    
    func didBulletColideAsteroid() {
        score += Constants.asteroidScore
        DispatchQueue.main.async {
            self.scoreLabel.text = "Score: \(self.score)"
        }
    }
    
    func didAsteroidColideSpaceship() {
        //TODO: Gameover
    }
}

// MARK: - ARSessionObserver -

extension GameViewController {
    
    func session(_ session: ARSession, didFailWithError error: Error) { }
    
    func sessionWasInterrupted(_ session: ARSession) { }
    
    func sessionInterruptionEnded(_ session: ARSession) { }
}
