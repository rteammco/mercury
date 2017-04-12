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
  var barWidth: CGFloat?
  var healthBarNode: SKShapeNode?
  var healthBarText: SKLabelNode?
  var experienceBarNode: SKShapeNode?
  
  init(gameState: GameState) {
    self.initialHealth = gameState.getCGFloat(forKey: .playerHealth)
    super.init(position: CGPoint(x: 0, y: 0), gameState: gameState)
    self.gameState.subscribe(self, to: .playerHealth)
    self.gameState.subscribe(self, to: .playerDied)
    self.gameState.subscribe(self, to: .totalPlayerExperience)
  }
  
  // Updates when player health changes or when player dies.
  override func reportStateChange(key: GameStateKey, value: Any) {
    switch key {
    case .playerHealth:
      if self.initialHealth > 0 {
        let currentHealth = self.gameState.getCGFloat(forKey: .playerHealth)
        let ratio = currentHealth / self.initialHealth
        updateHealthBar(withHealthRatio: ratio)
      }
    case .playerDied:
      updateHealthBar(withHealthRatio: 0)
    case .totalPlayerExperience:
      // TODO: What's the current max XP value? Compute the ratio accurately!
      if let totalExperience = value as? Int {
        let maxExperience = 1000
        let ratio = CGFloat(totalExperience) / CGFloat(maxExperience)
        updateExperienceBar(withExperienceRatio: ratio)
      }
    default:
      break
    }
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
  
  private func updateExperienceBar(withExperienceRatio experienceRatio: CGFloat) {
    var ratio = experienceRatio
    if ratio > 1.0 {
      ratio = 1.0
    } else if ratio < 0.0 {
      ratio = 0.0
    }
    if let experienceBar = self.experienceBarNode {
      experienceBar.xScale = ratio
      if let barWidth = self.barWidth {
        let xOffset: CGFloat = (barWidth * (1.0 - ratio)) / 2.0
        experienceBar.position.x = -xOffset
      }
    }
  }
  
  // Sets up the HUD node, which contains children nodes (the health bar and text) that get updated as the level continues.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    // The HUD node itself is just the outline of the health bar. We will add things in and around it.
    let width = 0.7 * scale
    self.barWidth = width
    let height = 0.05 * scale
    let hudNode = SKShapeNode(rectOf: CGSize(width: width, height: height))
    hudNode.position = CGPoint(x: 0, y: scale * 0.8)
    hudNode.lineWidth = 3.0
    hudNode.strokeColor = SKColor.red
    
    // Create the health bar part of the HUD.
    let healthBarNode = SKShapeNode(rectOf: CGSize(width: width, height: height))
    healthBarNode.position = CGPoint(x: 0, y: 0)  // Centered on the HUD node.
    healthBarNode.fillColor = GameConfiguration.hudHealthBarColor
    healthBarNode.alpha = GameConfiguration.hudBarAlpha
    self.healthBarNode = healthBarNode
    hudNode.addChild(healthBarNode)
    
    // Create the text (health %) in the node.
    let healthBarText = SKLabelNode(text: "100%")
    healthBarText.position = CGPoint(x: 0, y: 0)  // Centered on the HUD node.
    healthBarText.color = GameConfiguration.hudHealthTextColor
    healthBarText.fontName = GameConfiguration.hudHealthTextFont
    healthBarText.fontSize = GameConfiguration.hudHealthTextFontSize
    healthBarText.verticalAlignmentMode = .center
    self.healthBarText = healthBarText
    hudNode.addChild(healthBarText)
    
    // Create the XP bar.
    let experienceBarHeight = 0.01 * scale
    let experienceBar = SKShapeNode(rectOf: CGSize(width: width, height: experienceBarHeight))
    experienceBar.position = CGPoint(x: 0, y: (height / 2.0 + 3.0))  // Right above the HP bar.
    experienceBar.fillColor = GameConfiguration.hudExperienceBarColor
    experienceBar.alpha = GameConfiguration.hudBarAlpha
    self.experienceBarNode = experienceBar
    updateExperienceBar(withExperienceRatio: 0.0)  // TODO: Update to current XP value.
    hudNode.addChild(experienceBar)
    
    // Add the node to the scene.
    hudNode.zPosition = GameConfiguration.hudZPosition
    self.gameSceneNode = hudNode
    return hudNode
  }
  
}
