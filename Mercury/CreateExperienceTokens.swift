//
//  CreateExperienceTokens.swift
//  Mercury
//
//  Created by Richard Teammco on 4/12/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  Creates an experience token at the location of the dead enemy.

import SpriteKit

class CreateExperienceTokens: EventAction {
  
  let experienceAmount: Int
  
  init(withExperienceAmount experienceAmount: Int) {
    self.experienceAmount = experienceAmount
  }
  
  override func execute(withOptionalValue enemy: Any? = nil) {
    if let gameScene = self.caller {
      let gameState = gameScene.getGameState()
      if let playerStatus = gameState.get(valueForKey: .playerStatus) as? PlayerStatus {
        playerStatus.addPlayerExperience(self.experienceAmount)
        gameState.inform(.playerExperienceChange)
      }
      // TODO: Instead of setting the XP directly, create the actual tokens at the enemy's location, which will "carry" to XP to the player in an animated flashy way.
//      print("Creating XP tokens")
//      if let _ = enemy as? Enemy {
//        print("Got enemy as optional value")
//      }
    }
  }
  
}
