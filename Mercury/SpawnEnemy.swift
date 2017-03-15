//
//  SpawnBasicEnemy.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An EventAction that spawns the enemy of the given name when triggered.

import SpriteKit

class SpawnEnemy: EventAction {
  
  // TODO: location, and actually switch between the appropriate enemies.
  init(_ enemyName: String) {
    
  }

  override func execute() {
    if let gameScene = self.caller as? GameScene {
      let gameState = gameScene.getGameState()
      let enemy = Enemy(position: gameScene.getScaledPosition(CGPoint(x: 0, y: 0)), speed: 0.15)
      gameState.inform("enemy spawned", value: enemy)
      
      // Update the global game state by incrementing the enemy spawn count value.
      let numEnemiesSpawned = gameState.getInt(forKey: "enemy spawn count")
      gameState.set("enemy spawn count", to: numEnemiesSpawned + 1)
    }
  }
  
}
