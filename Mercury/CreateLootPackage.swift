//
//  CreateExperienceTokens.swift
//  Mercury
//
//  Created by Richard Teammco on 4/12/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  Creates a loot package at the location of the dead enemy. The loot package typically contains experience, resources, and possibly items, generated randomly based on the type of enemy and its available loot tables.

import SpriteKit

class CreateLootPackage: EventAction {
  
  // This is the maximum number of orbs that get spawned. If the maximum reward value would require more orbs than this limit, that amount will be distributed evenly across all orbs.
  static let kMaxNumberOfOrbsPerType: Int = 10
  
  // TODO: This is the amount of XP that can be contained in a single XP orb.
  let numExperiencePointsPerOrb: Int = 5
  let numHealthPointsPerOrb: CGFloat = 25
  
  let lootPackage: LootPackage
  
  // TODO: This should drop items, beyond just experience.
  init(lootPackage: LootPackage) {
    self.lootPackage = lootPackage
  }
  
  private func createOrbs(ofType orbType: LootItem.ItemType, withQuanity value: CGFloat, withMaxValuePerOrb maxOrbValue: CGFloat, withinRegion region: CGRect, gameScene: GameScene) {
    let gameState = gameScene.getGameState()
    let valuePerOrb: CGFloat = max(maxOrbValue, value / CGFloat(CreateLootPackage.kMaxNumberOfOrbsPerType))
    
    var amountRemaining: CGFloat = value
    while amountRemaining > 0 {
      // Create the orb at a random position within the bounding region.
      let orbPosition = Util.getRandomPointInRectangle(region)
      let orbValue = min(valuePerOrb, amountRemaining)
      var orb: LootItem?
      // Initialize orb depending on what type it is.
      if orbType == .ExperienceOrb {
        orb = LootItem(position: orbPosition, gameState: gameState, withExperience: Int(orbValue))
      } else if orbType == .HealthOrb {
        orb = LootItem(position: orbPosition, gameState: gameState, withHealth: orbValue)
      }
      // Add orb to the scene.
      if let orbObject = orb {
        gameScene.addGameObject(orbObject)
        // Punt the vector towards an arbitrary direction for added randomness.
        let impulseVector = Util.getRandomUnitVector()
        orbObject.applyImpulse(Util.scaleVector(impulseVector, by: gameScene.getScaledValue(0.5)))
      }
      amountRemaining -= valuePerOrb
    }
  }
  
  override func execute(withOptionalValue enemy: Any? = nil) {
    if let gameScene = self.caller, let enemy = enemy as? Enemy {
      let loot = self.lootPackage.generateLoot()
      let enemyBoundingBox = enemy.getBoundingBox()
      createOrbs(ofType: .ExperienceOrb, withQuanity: CGFloat(loot.experience), withMaxValuePerOrb: CGFloat(numExperiencePointsPerOrb), withinRegion: enemyBoundingBox, gameScene: gameScene)
      createOrbs(ofType: .HealthOrb, withQuanity: loot.health, withMaxValuePerOrb: numHealthPointsPerOrb, withinRegion: enemyBoundingBox, gameScene: gameScene)
    }
  }
  
}
