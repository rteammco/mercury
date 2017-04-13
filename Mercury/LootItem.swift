//
//  LootItem.swift
//  Mercury
//
//  Created by Richard Teammco on 4/13/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A loot item is an object that drops from enemies or random sources and moves towards the player or waits for the player to come to it. Once it collides with the player, it will reward the player with the contents (e.g. experience, items, etc.).

import SpriteKit

class LootItem: PhysicsEnabledGameObject {
  
  let experiencePoints: Int
  
  init(position: CGPoint, gameState: GameState, withExperience experiencePoints: Int) {
    self.experiencePoints = experiencePoints
    super.init(position: position, gameState: gameState)
    self.nodeName = "loot"
    
    setCollisionCategory(PhysicsCollisionBitMask.item)
    addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    addFieldAttractionBitMask(PhysicsCollisionBitMask.playerGravityField)
  }
  
  // TODO: temporary color and shape.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let radius = 0.02 * scale
    let node = SKShapeNode(circleOfRadius: radius)
    node.position = getPosition()
    node.fillColor = SKColor.green
    self.gameSceneNode = node
    self.initializePhysics()
    return node
  }
  
  func applyReward() {
    if let playerStatus = gameState.get(valueForKey: .playerStatus) as? PlayerStatus {
      playerStatus.addPlayerExperience(self.experiencePoints)
      gameState.inform(.playerExperienceChange)
    }
  }
  
}
