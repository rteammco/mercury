//
//  ExperienceOrb.swift
//  Mercury
//
//  Created by Richard Teammco on 4/15/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A health orb flies towards the player and upon collision returns health of the specified quantity.

import SpriteKit

class HealthOrb: LootItem {
  
  let healthPoints: CGFloat
  
  init(position: CGPoint, gameState: GameState, withHealth healthPoints: CGFloat) {
    self.healthPoints = healthPoints
    super.init(position: position, gameState: gameState)
    self.nodeName = "health orb"
    
    setCollisionCategory(PhysicsCollisionBitMask.item)
    addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    addFieldAttractionBitMask(PhysicsCollisionBitMask.playerGlobalLootGravityField)
  }
  
  // Creates the LootItem node depending on the type of loot item this is.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let radius = 0.005 * scale
    return createLootOrb(ofRadius: radius, withColor: GameConfiguration.hudHealthBarColor, withAnimationFile: "LootOrbHealth.sks")
  }
  
  // Rewards the player with the experience points.
  override func applyReward() {
    self.gameState.inform(.playerHealthChange, value: self.healthPoints)
  }
  
  // Force this orb to move towards the player at all times.
  override func update(elapsedTime timeSinceLastUpdate: TimeInterval) {
    restrictItemDistanceFromPlayer()
  }
  
}
