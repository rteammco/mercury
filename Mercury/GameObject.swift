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
  var gameSceneNode: SKShapeNode?
  
  // How fast the object moves in the world.
  var movementSpeed = 1.0
  
  // This node name is assigned to the sprite/shape nodes returned by getSceneNode(). Use an identifier for detecting those nodes in the scene.
  var nodeName = "object"
  
  // Returns the distance of this object (its node) to to given point. Returns 0 if the node is not defined.
  func distanceTo(loc: CGPoint) -> Double {
    if let gameSceneNode = self.gameSceneNode {
      let xDist = loc.x - gameSceneNode.position.x
      let yDist = loc.y - gameSceneNode.position.y
      return Double(sqrt(xDist * xDist + yDist * yDist))
    }
    return 0.0
  }
  
  // Moves the scene node to the given location. Removes any previous move actions.
  func moveTo(to loc: CGPoint, duration: Double) {
    if let gameSceneNode = self.gameSceneNode {
      let time = duration / self.movementSpeed
      gameSceneNode.removeAction(forKey: "moveAction")
      gameSceneNode.run(SKAction.move(to: loc, duration: time), withKey: "moveAction")
    }
  }
  
  func moveBy(dx: CGFloat, dy: CGFloat) {
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.position = CGPoint(x: gameSceneNode.position.x + dx, y: gameSceneNode.position.y + dy)
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
  
  // Updates the GameObject given the elapsed time (in seconds) since the last frame.
  func update(_ elapsedTime: TimeInterval) {
    // Override as needed. Otherwise, this does nothing.
  }
  
}
