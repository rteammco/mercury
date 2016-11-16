//
//  GameScene.swift
//  Mercury
//
//  Created by Richard Teammco on 11/12/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  // The player game object.
  private var player: Player?
  
  // A line that fades out over time.
  private var linePathNode: SKShapeNode?
  
  // The size of the world (half of the average of the width and height).
  private var worldSize: Double?
  
  // If set, this indicates the first and most recent touch positions.
  private var lastTouchPosition: CGPoint?
  
  // Called whenever the scene is presented into the view.
  override func didMove(to view: SKView) {
    self.worldSize = Double(self.size.width + self.size.height) / 4.0
    
    // Add the player to the bottom of the screen
    let size = (self.size.width + self.size.height) * 0.05
    let xPos = 0
    let yPos = Int(-self.size.height / 2 + size)
    self.player = Player(xPos: xPos, yPos: yPos, size: Int(size))
    if let player = self.player {
      self.addChild(player.getSceneNode())
    }
    
    // Create a template for the fading-out lines to be rendered to visualize touches.
    self.linePathNode = SKShapeNode.init()
    if let linePathNode = self.linePathNode {
      linePathNode.lineWidth = 25.0
      linePathNode.strokeColor = SKColor.green
      linePathNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),
                                          SKAction.removeFromParent()]))
    }
  }
  
  // Adds the given GameObject type to the scene by appending its node.
  func addGameObject(gameObject: GameObject) {
    if let gameSceneNode = gameObject.gameSceneNode {
      self.addChild(gameSceneNode)
    }
  }
  
  // Returns the previous position on the screen that a user's touch occured. The previous location is the one before the latest touch action. If no touch was previously recorded, returns (0, 0) which is the center of the screen.
  func getPreviousTouchPosition() -> CGPoint {
    if let previousTouchPosition = self.lastTouchPosition {
      return previousTouchPosition
    } else {
      return CGPoint(x: 0, y: 0)
    }
  }
  
  // Checks if player has been touched (thus toggled for movement), and then moves the player to the given location.
  func movePlayerIfTouched(to pos: CGPoint) {
    if let player = self.player, let worldSize = self.worldSize {
      if player.isTouched {
        let distance = player.distanceTo(loc: pos)
        let duration = distance / worldSize
        player.moveTo(to: pos, duration: duration)
      }
    }
  }
  
  func touchDown(atPoint pos: CGPoint) {
    let touchedNodes = self.nodes(at: pos)
    for node in touchedNodes {
      if node.name == self.player?.nodeName {
        self.player?.touchDown()
      }
    }
    self.lastTouchPosition = pos
  }
  
  func touchMoved(toPoint pos: CGPoint) {
    if let lastTouchPosition = self.lastTouchPosition, let linePathNode = self.linePathNode?.copy() as! SKShapeNode? {
      let path = CGMutablePath.init()
      path.move(to: lastTouchPosition)
      path.addLine(to: pos)
      linePathNode.path = path
      self.addChild(linePathNode)
    }
    self.lastTouchPosition = pos
  }
  
  func touchUp(atPoint pos: CGPoint) {
    self.movePlayerIfTouched(to: pos)
    // Separately, if the player is touched, un-touch it.
    if let player = self.player {
      if player.isTouched {
        player.touchUp()
      }
    }
  }
  
  // Called when user starts a touch action.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  // Called when user moves (drags) during a touch action.
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  // Called when user finishes a touch action.
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  // Called when a touch action is interrupted or otherwise cancelled.
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }
  
}
