//
//  Player.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//

import SpriteKit

class Player: InteractiveGameObject {
  
  // How often the player fires a bullet (in seconds) when firing.
  private var fireIntervalSeconds: Double
  
  init(xPos: Int, yPos: Int, size: Int) {
    self.fireIntervalSeconds = 0.25
    super.init()
    self.nodeName = "player"
    self.movementSpeed = 4.0
    
    // TODO: temporary color and shape
    self.gameSceneNode = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.position = CGPoint(x: xPos, y: yPos)
      gameSceneNode.fillColor = SKColor.blue
    }
  }
  
  override func touchDown() {
    super.touchDown()
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.fillColor = SKColor.red
    }
  }
  
  override func touchUp() {
    super.touchUp()
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.fillColor = SKColor.blue
    }
  }
  
}
