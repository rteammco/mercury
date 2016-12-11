//
//  PhysicsEnabledGameObject.swift
//  Mercury
//
//  Created by Richard Teammco on 12/11/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//

import SpriteKit

class PhysicsEnabledGameObject: GameObject, PhysicsEnabled {

  // TODO: self.gameSceneNode?.physicsBody?.categoryBitMask ...?
  
  override init(gameScene: GameScene, position: CGPoint) {
    super.init(gameScene: gameScene, position: position)
    createPhysicsBody()
  }
  
  // Creates a circular physics body (the most basic collision check) with default physical properties.
  // Override as needed for each GameObject.
  // Called in PhysicsEnabledGameObject's init().
  func createPhysicsBody() {
    if let gameSceneNode = self.gameSceneNode {
      // Simple circular physics body. This can be defined as an arbitrary polygon for more realistic physical simulations.
      gameSceneNode.physicsBody = SKPhysicsBody(circleOfRadius: gameSceneNode.frame.size.width / 2)
      
      gameSceneNode.physicsBody?.friction = 0.0          // Amount of resistance applied to other objects that touch this one's surface.
      gameSceneNode.physicsBody?.mass = 0.0              // Determines how forces act on the obejct as well as momentum; 0.0 = forces control it completely and immediately.
      gameSceneNode.physicsBody?.restitution = 1.0       // How much energy is preserved on collision (i.e. bounciness); 1.0 = all energy is maintained.
      
      gameSceneNode.physicsBody?.linearDamping = 0.0     // Movement friction as object moves through the world (e.g. to simulate friction due to air).
      gameSceneNode.physicsBody?.angularDamping = 0.0    // Same but for angular friction.
      
      gameSceneNode.physicsBody?.allowsRotation = false  // true = forces can impact angular velocity.
      gameSceneNode.physicsBody?.isDynamic = true        // true = this object is simulated by the physics subsystem; false = only acts on other objects (e.g. user-controlled objects).
    }
  }
  
  func applyImpulse(dx: CGFloat, dy: CGFloat) {
    self.gameSceneNode?.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
  }
  
  // Applies an impulse based on the movement speed and direction of the GameObject.
  func applyDefaultImpulse() {
    let dx = self.movementDirection.dx * self.movementSpeed
    let dy = self.movementDirection.dy * self.movementSpeed
    self.applyImpulse(dx: dx, dy: dy)
  }
  
}
