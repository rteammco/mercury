//
//  GameObject.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The GameObject provides a collection of methods and properties shared by all visible objects that can exist in the game scene. This includes interactive nodes, such as the player or enemies, as well as non-interactive visual elements such as touch visualization effects.
//

import SpriteKit

class GameObject {
  
  // The scene node for animation and rendering.
  var gameSceneNode : SKShapeNode?
  
  // How fast the object moves in the world.
  var movementSpeed = 1.0
  
  // This node name is assigned to the sprite/shape nodes returned by getSceneNode(). Use an identifier for detecting those nodes in the scene.
  var nodeName = "object"
  
  // Moves the scene node to the given location.
  func moveTo(to loc : CGPoint, duration: Double) {
    if let gameSceneNode = self.gameSceneNode {
      let time = duration / self.movementSpeed
      gameSceneNode.run(SKAction.move(to: loc, duration: time))
    }
  }

  // Returns the scene node for this object. If it was not initialized, the returned object will be an empty SKShapeNode.
  func getSceneNode() -> SKShapeNode {
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.name = self.nodeName
      return gameSceneNode
    } else {
      return SKShapeNode()
    }
  }
  
}
