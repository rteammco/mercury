//
//  SwipePathAnimation.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  This animation draws a line along a path following the user dragging their finger across the screen.

import SpriteKit

class SwipePathAnimation {
  
  let linePathNode: SKShapeNode
  
  init() {
    self.linePathNode = SKShapeNode.init()
    self.linePathNode.lineWidth = 5.0
    self.linePathNode.strokeColor = SKColor.green
    self.linePathNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),
                                             SKAction.removeFromParent()]))
  }
  
}
