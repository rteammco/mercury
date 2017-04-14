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
  
  // TODO: This is the amount of XP that can be contained in a single XP orb.
  let numExperiencePointsPerOrb: Int = 5
  let numHealthPointsPerOrb: CGFloat = 25
  
  let lootPackage: LootPackage
  
  // TODO: This should drop items, beyond just experience.
  init(lootPackage: LootPackage) {
    self.lootPackage = lootPackage
  }
  
  override func execute(withOptionalValue enemy: Any? = nil) {
    if let gameScene = self.caller, let enemy = enemy as? Enemy {
      let gameState = gameScene.getGameState()
      let loot = self.lootPackage.generateLoot()
      
      // Create XP "orbs", based on the amount of experience to be awarded.
      let enemyBoundingBox = enemy.getBoundingBox()
      var experienceRemaining = loot.experience
      while experienceRemaining > 0 {
        let experienceOrbPosition = Util.getRandomPointInRectangle(enemyBoundingBox)
        let experienceOrb = LootItem(position: experienceOrbPosition, gameState: gameState, withExperience: min(self.numExperiencePointsPerOrb, experienceRemaining))
        gameScene.addGameObject(experienceOrb)
        let impulseVector = Util.getRandomUnitVector()
        experienceOrb.applyImpulse(Util.scaleVector(impulseVector, by: gameScene.getScaledValue(0.5)))
        experienceRemaining -= self.numExperiencePointsPerOrb
      }
      
      // Create health "orbs".
      var healthRemaining = loot.health
      while healthRemaining > 0 {
        let healthOrbPosition = Util.getRandomPointInRectangle(enemyBoundingBox)
        let healthOrb = LootItem(position: healthOrbPosition, gameState: gameState, withHealth: min(self.numHealthPointsPerOrb, healthRemaining))
        gameScene.addGameObject(healthOrb)
        let impulseVector = Util.getRandomUnitVector()
        healthOrb.applyImpulse(Util.scaleVector(impulseVector, by: gameScene.getScaledValue(0.5)))
        healthRemaining -= self.numHealthPointsPerOrb
      }
    }
  }
  
}
