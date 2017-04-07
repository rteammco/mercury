//
//  Bullet.swift
//  Mercury
//
//  Created by Richard Teammco on 11/30/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  A standard bullet that flies in a particular direction until it collides with another object or otherwise flies out of the current Level scene. Bullets are not user-interactive, but interact with other objects in the game.

import SpriteKit

// TODO: We might want to make a super class for Projectiles in general, since there will likely be common functionality between all of the projectiles.
class Bullet: PhysicsEnabledGameObject {
  
  // The color of the bullet.
  private var color: SKColor
  
  // The amount of damage this bullet does on impact.
  private let damage: CGFloat
  
  init(position: CGPoint, gameState: GameState, speed: CGFloat, damage: CGFloat) {
    self.color = SKColor.yellow
    self.damage = damage
    super.init(position: position, gameState: gameState)
    self.nodeName = "bullet"
    self.scaleMovementSpeed(speed)
    
    // Customize physics properties:
    self.physicsMass = 0.0
    self.physicsRestitution = 0.15
    self.physicsFriction = 0.15
    self.physicsAllowsRotation = true
    setCollisionCategory(PhysicsCollisionBitMask.projectile)
  }
  
  // Set this bullet's color.
  func setColor(to color: SKColor) {
    self.color = color
  }
  
  // TODO: temporary color and shape.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let width = 0.04 * scale
    let height = 0.01 * scale
    let node = SKShapeNode(rectOf: CGSize(width: width, height: height))
    node.position = getPosition()
    node.zRotation = Util.getOrientation(of: self.movementDirection)
    node.fillColor = self.color
    self.gameSceneNode = node
    self.initializePhysics()
    return node
  }
  
  func getHitDamage() -> CGFloat {
    return self.damage
  }
  
}
