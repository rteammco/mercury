//
//  Bullet.swift
//  Mercury
//
//  Created by Richard Teammco on 11/30/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//

import SpriteKit

class Bullet: GameObject {
  
  init(xPos: Int, yPos: Int, movementSpeed: Double) {
    super.init()
    self.nodeName = "bullet"
    self.movementSpeed = movementSpeed
    
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
    // TODO
  }
  
}
