//
//  ExperienceOrb.swift
//  Mercury
//
//  Created by Richard Teammco on 4/15/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An experience orb flies towards the player and upon collision awards experience points of the specified quantity.

import SpriteKit

class ExperienceOrb: LootItem {
  
  let experiencePoints: CGFloat
  
  init(position: CGPoint, gameState: GameState, withExperience experiencePoints: CGFloat) {
    self.experiencePoints = experiencePoints
    super.init(position: position, gameState: gameState)
    self.nodeName = "experience orb"
    
    setCollisionCategory(PhysicsCollisionBitMask.item)
    addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
  }
  
  // Creates the LootItem node depending on the type of loot item this is.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let radius = 0.005 * scale
    return createLootOrb(ofRadius: radius, withColor: GameConfiguration.hudExperienceBarColor, withAnimationFile: "LootOrbExperience.sks")
  }
  
  // Rewards the player with the experience points.
  override func applyReward() {
    if let playerStatus = self.gameState.get(valueForKey: .playerStatus) as? PlayerStatus {
      playerStatus.addPlayerExperience(Int(experiencePoints))  // Convert to Int.
      self.gameState.inform(.playerExperienceChange)
    }
  }
  
}
