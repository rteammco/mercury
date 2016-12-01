//
//  Enemy.swift
//  Mercury
//
//  Created by Richard Teammco on 12/1/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  An abstract Enemy object that should be extended to include specific enemies. This defines standard actions that most enemy units will take, such as random-interval shooting.

import SpriteKit

class Enemy: GameObject {
  
  init(xPos: CGFloat, yPos: CGFloat, speed: Double) {
    super.init()
    self.nodeName = "enemy"
    self.scaleMovementSpeed(speed)
    self.setMovementDirection(dx: 0, dy: -1)  // Top to bottom of screen.
    
    // TODO: temporary color and shape
    self.gameSceneNode = SKShapeNode.init(rectOf: CGSize.init(width: 150, height: 150))
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.position = CGPoint(x: xPos, y: yPos)
      gameSceneNode.fillColor = SKColor.cyan
    }
  }
  
  // Moves down every frame until it flies off screen.
  override func update(_ elapsedTime: TimeInterval) {
    self.moveUpdate(elapsedTime: elapsedTime)
    if !self.isWithinScreenBounds() {
      self.isAlive = false
    }
  }
  
}
