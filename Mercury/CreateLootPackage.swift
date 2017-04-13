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
  
  let experienceAmount: Int
  
  // TODO: This should drop items, beyond just experience.
  init(withExperienceAmount experienceAmount: Int) {
    self.experienceAmount = experienceAmount
  }
  
  override func execute(withOptionalValue enemy: Any? = nil) {
    if let gameScene = self.caller, let enemy = enemy as? Enemy {
      let gameState = gameScene.getGameState()
      let lootItem = LootItem(position: enemy.getPosition(), gameState: gameState, withExperience: self.experienceAmount)
      gameScene.addGameObject(lootItem)
    }
  }
  
}
