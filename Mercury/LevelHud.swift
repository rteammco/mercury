//
//  PlayerHud.swift
//  Mercury
//
//  Created by Richard Teammco on 4/7/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The LevelHud handles displaying information about the player and level.

import SpriteKit

class LevelHud: GameObject {
  
  let initialHealth: CGFloat
  
  init(gameState: GameState) {
    self.initialHealth = gameState.getCGFloat(forKey: .playerHealth)
    super.init(position: CGPoint(x: 0, y: 0), gameState: gameState)
    self.gameState.subscribe(self, to: .playerHealth)
    self.gameState.subscribe(self, to: .playerDied)
  }
  
  override func reportStateChange(key: GameStateKey, value: Any) {
    if key == .playerHealth {
      if self.initialHealth > 0 {
        let currentHealth = self.gameState.getCGFloat(forKey: .playerHealth)
        let ratio = currentHealth / self.initialHealth
        self.gameSceneNode?.xScale = ratio
      }
    }
    if key == .playerDied {
      print("HUD SAY PLAYER DIED")
    }
  }
  
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    // Override as needed.
    let width = 0.8 * scale
    let height = 0.05 * scale
    let node = SKShapeNode.init(rectOf: CGSize.init(width: width, height: height))
    node.position = CGPoint(x: 0, y: scale * 0.8)
    node.fillColor = SKColor.red
    self.gameSceneNode = node
    return node
  }
  
}
