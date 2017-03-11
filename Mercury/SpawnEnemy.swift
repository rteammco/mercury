//
//  SpawnBasicEnemy.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An EventAction that spawns the enemy of the given name when triggered.

class SpawnEnemy: EventAction {
  
  // TODO: location, and actually switch between the appropriate enemies.
  init(_ enemyName: String) {
    
  }

  override func execute() {
    if let gameScene = self.caller as? GameScene {
      gameScene.displayTextOnScreen(message: "Spawning an enemy")  // TODO: change.
      // Update the global game state by incrementing the enemy spawn count value.
      let gameState = gameScene.getGameState()
      let numEnemiesSpawned = gameState.getInt(forKey: "enemy spawn count")
      gameState.set("enemy spawn count", to: numEnemiesSpawned + 1)
    }
  }
  
}
