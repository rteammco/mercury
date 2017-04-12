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
  var healthBarNode: SKShapeNode?
  var healthBarText: SKLabelNode?
  
  init(gameState: GameState) {
    self.initialHealth = gameState.getCGFloat(forKey: .playerHealth)
    super.init(position: CGPoint(x: 0, y: 0), gameState: gameState)
    self.gameState.subscribe(self, to: .playerHealth)
    self.gameState.subscribe(self, to: .playerDied)
  }
  
  // Updates the health bar and text given the ratio of health (ratio between max health and the current health). Ratio will always be normalized between 0 and 1.
  private func updateHealthBar(withHealthRatio healthRatio: CGFloat) {
    var ratio = healthRatio
    if ratio > 1.0 {
      ratio = 1.0
    } else if ratio < 0.0 {
      ratio = 0.0
    }
    self.healthBarNode?.xScale = ratio
    if ratio > 0 {
      let percent = Int(round(100 * ratio))
      self.healthBarText?.text = String(percent) + "%"
    } else {
      self.healthBarText?.text = "x_x"
    }
  }
  
  // Updates when player health changes or when player dies.
  override func reportStateChange(key: GameStateKey, value: Any) {
    if key == .playerHealth {
      if self.initialHealth > 0 {
        let currentHealth = self.gameState.getCGFloat(forKey: .playerHealth)
        let ratio = currentHealth / self.initialHealth
        updateHealthBar(withHealthRatio: ratio)
      }
    }
    if key == .playerDied {
      updateHealthBar(withHealthRatio: 0)
    }
  }
  
  // Sets up the HUD node, which contains children nodes (the health bar and text) that get updated as the level continues.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let width = 0.8 * scale
    let height = 0.05 * scale
    let hudNode = SKShapeNode(rectOf: CGSize(width: width, height: height))
    hudNode.position = CGPoint(x: 0, y: scale * 0.8)
    hudNode.lineWidth = 3.0
    hudNode.strokeColor = SKColor.red
    
    // Create the health bar part of the HUD.
    let healthBarNode = SKShapeNode(rectOf: CGSize(width: width, height: height))
    healthBarNode.fillColor = GameConfiguration.hudHealthBarColor
    healthBarNode.alpha = GameConfiguration.hudHealthBarAlpha
    self.healthBarNode = healthBarNode
    hudNode.addChild(healthBarNode)
    
    // Create the text (health %) in the node.
    let healthBarText = SKLabelNode(text: "100%")
    healthBarText.color = GameConfiguration.hudHealthTextColor
    healthBarText.fontName = GameConfiguration.hudHealthTextFont
    healthBarText.fontSize = GameConfiguration.hudHealthTextFontSize
    healthBarText.verticalAlignmentMode = .center
    self.healthBarText = healthBarText
    hudNode.addChild(healthBarText)
    
    hudNode.zPosition = GameConfiguration.hudZPosition
    self.gameSceneNode = hudNode
    return hudNode
  }
  
}
