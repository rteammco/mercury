//
//  HandlePlayerDeath.swift
//  Mercury
//
//  Created by Richard Teammco on 4/17/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  Handles the death of the Player.

import SpriteKit

class HandlePlayerDeath: EventAction {
  
  override func execute(withOptionalValue optionalValue: Any? = nil) {
    if let gameScene = self.caller {
      let gameState = gameScene.getGameState()
      gameScene.displayTextOnScreen(message: "Player Died", forDuration: 2, withFadeOutDuration: 2)
      ParticleSystems.runExplosionEffect(atPosition: Util.getPlayerWorldPosition(fromGameState: gameState), withGameState: gameState)
      gameScene.setGameSpeed(to: 0.1)
      // TODO: This should also add a menu that will allow the player to reset to the last phase or go back to the main menu.
    }
  }
  
}
