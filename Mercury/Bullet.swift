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
class Bullet: GameObject {
  
  init(xPos: CGFloat, yPos: CGFloat, speed: Double) {
    super.init()
    self.nodeName = "bullet"
    self.scaleMovementSpeed(speed)
    
    // TODO: temporary color and shape
    self.gameSceneNode = SKShapeNode.init(rectOf: CGSize.init(width: 5, height: 20))
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.position = CGPoint(x: xPos, y: yPos)
      gameSceneNode.fillColor = SKColor.yellow
    }
  }
  
  // Moves the bullet forward at the given speed.
  // TODO: check for collisions.
  override func update(_ elapsedTime: TimeInterval) {
    self.moveUpdate(elapsedTime: elapsedTime)
    if !self.isWithinScreenBounds() {
      self.isAlive = false
    }
  }
  
}
