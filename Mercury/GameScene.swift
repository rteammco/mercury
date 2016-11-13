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
  private var player : Player?
  
  // A line that fades out over time.
  private var linePathNode : SKShapeNode?
  
  // If set, this indicates the last position.
  private var lastTouchPosition : CGPoint?
  
  // Template for the node (animated).
  // TODO: remove this, and its initialization in didMove()
  private var spinnyNode : SKShapeNode?
  
  // Called whenever the scene is presented into the view.
  override func didMove(to view: SKView) {
    // Add the player to the bottom of the screen
    let size = (self.size.width + self.size.height) * 0.05
    let xPos = 0
    let yPos = Int(-self.size.height / 2 + size)
    self.player = Player(xPos :xPos, yPos: yPos, size: Int(size))
    if let player = self.player {
      self.addChild(player.getSceneNode())
    }
    
    // Create a template for the fading-out lines to be rendered to visualize touches.
    //self.linePathNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
    self.linePathNode = SKShapeNode.init()
    if let linePathNode = self.linePathNode {
      linePathNode.lineWidth = 25.0
      linePathNode.strokeColor = SKColor.green
      linePathNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),
                                          SKAction.removeFromParent()]))
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
    let touchedNodes = self.nodes(at: pos)
    for node in touchedNodes {
      if node.name == self.player?.nodeName {
        self.player?.touchDown()
      }
    }
    self.lastTouchPosition = pos
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if let lastTouchPosition = self.lastTouchPosition, let linePathNode = self.linePathNode?.copy() as! SKShapeNode? {
      let path = CGMutablePath.init()
      path.move(to: lastTouchPosition)
      path.addLine(to: pos)
      linePathNode.path = path
      self.addChild(linePathNode)
    }
    self.lastTouchPosition = pos
  }
  
  func touchUp(atPoint pos : CGPoint) {
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
