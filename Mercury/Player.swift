//
//  Player.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//

import SpriteKit

class Player : GameObject {
  
  init(xPos: Int, yPos: Int, size: Int) {
    super.init()
    
    self.gameSceneNode = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    if let gameSceneNode = self.gameSceneNode {
      // Position at bottom center (screen is centered at (0, 0))
      gameSceneNode.position = CGPoint(x: xPos, y: yPos)
      // TODO: temporary color and shape
      gameSceneNode.fillColor = SKColor.blue
    }
  }
  
}
