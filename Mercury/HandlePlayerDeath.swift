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
      ParticleSystems.runExplosionEffect(atPosition: Util.getPlayerWorldPosition(fromGameState: gameState), withGameState: gameState)
      gameScene.setGameSpeed(to: 0.1)
      
      let playerDiedMenu = MenuNode(inFrame: gameScene.frame, withBackgroundAlpha: 0.5)
      playerDiedMenu.add(label: SKLabelNode(text: "Player Died"))
      
      let tryAgainButton = ButtonNode.menuButton(withText: "Try Again")
      tryAgainButton.setCallback {
        playerDiedMenu.removeFromParent()
        gameScene.setGameSpeed(to: 1.0)
        gameScene.reset()
        gameState.set(.canPauseGame, to: true)
      }
      playerDiedMenu.add(button: tryAgainButton)
      
      let mainMenuButton = ButtonNode.menuButton(withText: "Main Menu")
      mainMenuButton.setCallback {
        gameScene.setCurrentLevel(to: MainMenu())
      }
      playerDiedMenu.add(button: mainMenuButton)
      
      gameState.set(.canPauseGame, to: false)
      gameScene.addChild(playerDiedMenu)
    }
  }
  
}
