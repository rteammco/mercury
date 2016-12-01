//
//  GameObject.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The GameObject provides a collection of methods and properties shared by all visible objects that can exist in the game scene. This includes interactive nodes, such as the player or enemies, as well as non-interactive visual elements such as touch visualization effects.

import SpriteKit

class GameObject {
  
  // The scene node for animation and rendering.
  var gameSceneNode: SKShapeNode?
  
  // Reference to the GameScene running the current Level.
  var gameScene: GameScene?
  
  // How fast the object moves in the world.
  // This is a relative value and is scaled by the GameScene depending on the screen size. It should only ever be modified with scaleMovementSpeed().
  private var movementSpeed: Double = 1.0
  
  // The direction of the object's motion (unit vector, scaled by movementSpeed).
  // By default, this motion is towards the top of the screen. Modify as needed with setMovementDirection().
  private var movementDirection = CGVector(dx: 0.0, dy: 1.0)
  
  // This node name is assigned to the sprite/shape nodes returned by getSceneNode(). Use an
  // identifier for detecting those nodes in the scene.
  var nodeName = "object"
  
  // This flag is used to trigger cleanup of objects at each frame. If isAlive is set to false, this object will be removed from the game during the next frame update.
  var isAlive: Bool = true
  
  // Scale the movement speed by the given non-negative value.
  func scaleMovementSpeed(_ speedScale: Double) {
    // Speed must be non-negative.
    if speedScale < 0 {
      return
    }
    self.movementSpeed *= speedScale
  }
  
  // Creates the Sprite node that gets added to the GameScene. The given scale is based on the size of the screen, so the node's size should adapt according to the screen size. The position is in absolute coordinates.
  // Override as needed. By default, creates a blue square of (relative) size 0.5 which is about a third of the screen's width.
  func createGameSceneNode(scale: Double, position: CGPoint) {
    let size = 0.5 * scale
    self.gameSceneNode = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.position = position
      gameSceneNode.fillColor = SKColor.blue
    }
  }
  
  // Set the movement direction. This will automatically normalize the given vector (must be non-zero).
  func setMovementDirection(dx: CGFloat, dy: CGFloat) {
    let norm = sqrt(dx * dx + dy * dy)
    // Cannot have a zero norm (divide by 0 error).
    if norm <= 0 {
      return
    }
    self.movementDirection.dx = dx / norm
    self.movementDirection.dy = dy / norm
  }
  
  // Returns true if this object is within screen bounds. Uses the GameScene's implementation.
  func isWithinScreenBounds() -> Bool {
    if let gameScene = self.gameScene {
      return gameScene.isGameObjectWithinScreenBounds(gameObject: self)
    }
    return true
  }
  
  // Returns the distance of this object (its node) to to given point. Returns 0 if the node is not
  // defined.
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
  
  // Moves the scene node by the given dx and dy instantly.
  func moveBy(dx: CGFloat, dy: CGFloat) {
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.position = CGPoint(x: gameSceneNode.position.x + dx, y: gameSceneNode.position.y + dy)
    }
  }
  
  // Updates the movement of this object in the given direction, scaled by the object's movement speed and the elapsed time interval.
  func moveUpdate(dx: CGFloat, dy: CGFloat, elapsedTime: TimeInterval) {
    print(self.movementSpeed)
    let dxScaled = dx * CGFloat(self.movementSpeed) * CGFloat(elapsedTime)
    let dyScaled = dy * CGFloat(self.movementSpeed) * CGFloat(elapsedTime)
    self.moveBy(dx: dxScaled, dy: dyScaled)
  }
  
  // Updates the movement of this object using the movementDirection vector.
  func moveUpdate(elapsedTime: TimeInterval) {
    self.moveUpdate(dx: self.movementDirection.dx, dy: self.movementDirection.dy, elapsedTime: elapsedTime)
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
  
  // Removes this object's scene node from the game scene.
  func removeSceneNodeFromGameScene() {
    self.gameSceneNode?.removeFromParent()
  }
  
  // Updates the GameObject given the elapsed time (in seconds) since the last frame.
  func update(_ elapsedTime: TimeInterval) {
    // Override as needed. Otherwise, this does nothing.
  }
  
}
