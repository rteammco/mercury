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
  var playerLevelTextNode: SKLabelNode?
  
  init(gameState: GameState) {
    self.initialHealth = gameState.getCGFloat(forKey: .playerHealth)
    super.init(position: CGPoint(x: 0, y: 0), gameState: gameState)
    self.gameState.subscribe(self, to: .playerHealth)
    self.gameState.subscribe(self, to: .playerDied)
    self.gameState.subscribe(self, to: .playerExperienceChange)
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
    case .playerExperienceChange:
      if let playerStatus = gameState.get(valueForKey: .playerStatus) as? PlayerStatus {
        updateLevelAndExperienceBar(playerStatus: playerStatus)
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
  
  // Updates the player level display experience bar visualization based on the given playerStatus variable.
  private func updateLevelAndExperienceBar(playerStatus: PlayerStatus) {
    var ratio = CGFloat(playerStatus.getCurrentPlayerExperience()) / CGFloat(playerStatus.playerExperienceRequiredToNextLevel())
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
    self.playerLevelTextNode?.text = String(playerStatus.getPlayerLevel())
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
    hudNode.addChild(experienceBar)
    
    // Create the player level text indicator.
    let playerLevelText = SKLabelNode(text: "??")
    playerLevelText.position = CGPoint(x: width / 1.8, y: 0)  // Left of the HP bar.
    playerLevelText.color = GameConfiguration.hudPlayerLevelTextColor
    playerLevelText.fontName = GameConfiguration.hudPlayerLevelTextFont
    playerLevelText.fontSize = GameConfiguration.hudPlayerLevelTextFontSize
    playerLevelText.verticalAlignmentMode = .center
    playerLevelText.horizontalAlignmentMode = .left
    self.playerLevelTextNode = playerLevelText
    hudNode.addChild(playerLevelText)
    
    // Set the current level and XP based on the current playerStatus.
    if let playerStatus = self.gameState.get(valueForKey: .playerStatus) as? PlayerStatus {
      updateLevelAndExperienceBar(playerStatus: playerStatus)
    }
    
    // Add the node to the scene.
    hudNode.zPosition = GameConfiguration.hudZPosition
    self.gameSceneNode = hudNode
    return hudNode
  }
  
}
