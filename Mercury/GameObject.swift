//
//  GameObject.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//

import SpriteKit

class GameObject {
  
  // The scene node for animation and rendering.
  var gameSceneNode : SKShapeNode?

  // Returns the scene node for this object. If it was not initialized, the returned object will be an empty SKShapeNode.
  func getSceneNode() -> SKShapeNode {
    if let gameSceneNode = self.gameSceneNode {
      return gameSceneNode
    } else {
      return SKShapeNode()
    }
  }
}
