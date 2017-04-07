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
  
  override func reportStateChange(key: GameStateKey, value: Any) {
    if key == .playerHealth {
      if self.initialHealth > 0 {
        let currentHealth = self.gameState.getCGFloat(forKey: .playerHealth)
        let ratio = currentHealth / self.initialHealth
        self.healthBarNode?.xScale = ratio
        let percent = Int(round(100 * ratio))
        let percentString = String(percent) + "%"
        self.healthBarText?.text = percentString
      }
    }
    if key == .playerDied {
      print("HUD SAY PLAYER DIED")
    }
  }
  
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let width = 0.8 * scale
    let height = 0.05 * scale
    let hudNode = SKShapeNode(rectOf: CGSize(width: width, height: height))
    hudNode.position = CGPoint(x: 0, y: scale * 0.8)
    hudNode.lineWidth = 3.0
    hudNode.strokeColor = SKColor.red
    
    // Create the health bar part of the HUD.
    let healthBarNode = SKShapeNode(rectOf: CGSize(width: width, height: height))
    healthBarNode.fillColor = SKColor.red
    self.healthBarNode = healthBarNode
    hudNode.addChild(healthBarNode)
    
    // Create the text (health %) in the node.
    let healthBarText = SKLabelNode(text: "100%")
    healthBarText.color = SKColor.white
    // TODO: Colors and font should be defined in GameConfiguration.
    healthBarText.fontName = "Arial-BoldMT"
    healthBarText.fontSize = 34
    // TODO: Center font in the parent node.
    self.healthBarText = healthBarText
    hudNode.addChild(healthBarText)
    
    self.gameSceneNode = hudNode
    return hudNode
  }
  
}
