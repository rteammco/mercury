//
//  Enemy.swift
//  Mercury
//
//  Created by Richard Teammco on 12/1/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  An abstract Enemy object that should be extended to include specific enemies. This defines standard actions that most enemy units will take, such as random-interval shooting.

import SpriteKit

class Enemy: PhysicsEnabledGameObject {
  
  init(position: CGPoint, gameState: GameState, speed: CGFloat) {
    super.init(position: position, gameState: gameState)
    self.nodeName = "enemy"
    self.scaleMovementSpeed(speed)
    self.setMovementDirection(dx: 0, dy: -1)  // Top to bottom of screen.
    
    // Customize physics properties:
    self.physicsMass = 1.0
    self.physicsRestitution = 0.5
    self.physicsFriction = 0.5
    self.physicsAllowsRotation = false
    
    // Physics collision properties: Enemies can collide with the player.
    setCollisionCategory(PhysicsCollisionBitMask.enemy)
    addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    // TODO: they should probably be able to collide with the environment as well?
  }
  
  // TODO: temporary color and shape.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let size = 0.2 * scale
    let node = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    node.position = self.position
    node.fillColor = SKColor.cyan
    self.gameSceneNode = node
    self.initializePhysics()
    return node
  }
  
}
