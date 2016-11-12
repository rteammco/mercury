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
  
  // The player node.
  private var playerNode : SKShapeNode?
  
  // Template for the node (animated).
  // TODO: remove this, and its initialization in didMove()
  private var spinnyNode : SKShapeNode?
  
  // Called whenever the scene is presented into the view.
  override func didMove(to view: SKView) {
    // Add the player to the bottom of the screen
    self.playerNode = SKShapeNode.init(rectOf: CGSize.init(width: 140, height: 140))
    if let playerNode = self.playerNode {
      // Screen is centered at (0, 0)
      let xPos = 0
      let yPos = -Int(self.size.height / 2) + 150
      playerNode.position = CGPoint(x: xPos, y: yPos)
      playerNode.fillColor = SKColor.green
      playerNode.lineWidth = 2.5
      playerNode.strokeColor = SKColor.red
      self.addChild(playerNode)
    }
    
    // Create shape node to use during mouse interaction
    // TODO: remove this
    let w = (self.size.width + self.size.height) * 0.05
    print(w)
    self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
    if let spinnyNode = self.spinnyNode {
      spinnyNode.lineWidth = 2.5
      spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
      spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                        SKAction.fadeOut(withDuration: 0.5),
                                        SKAction.removeFromParent()]))
      }
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
      n.position = pos
      n.strokeColor = SKColor.green
      self.addChild(n)
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
      n.position = pos
      n.strokeColor = SKColor.blue
      self.addChild(n)
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
      n.position = pos
      n.strokeColor = SKColor.red
      self.addChild(n)
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
