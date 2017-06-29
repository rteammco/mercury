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
      // Add an explosion at the player's location, slow down the game's speed, and stop the execution of the current active level phase.
      ParticleSystems.runExplosionEffect(atPosition: Util.getPlayerWorldPosition())
      gameScene.setGameSpeed(to: 0.1)
      gameScene.getCurrentPhase()?.stop()
      gameScene.releaseAllTouches()
      
      // Create a "Player Died" menu, with options to restart the last level phase or to return to the main menu.
      let playerDiedMenu = MenuNode(inFrame: gameScene.frame, withBackgroundAlpha: 0.5)
      playerDiedMenu.add(label: SKLabelNode(text: "Player Died"))
      
      let tryAgainButton = ButtonNode(withText: "Try Again")
      tryAgainButton.setCallback {
        playerDiedMenu.removeFromParent()
        gameScene.setGameSpeed(to: 1.0)
        gameScene.reset()
        GameScene.gameState.set(.canPauseGame, to: true)
      }
      playerDiedMenu.add(button: tryAgainButton)
      
      let mainMenuButton = ButtonNode(withText: "Main Menu")
      mainMenuButton.setCallback {
        gameScene.setCurrentLevel(to: MainMenu())
      }
      playerDiedMenu.add(button: mainMenuButton)
      
      GameScene.gameState.set(.canPauseGame, to: false)
      gameScene.addChild(playerDiedMenu)
    }
  }
  
}
