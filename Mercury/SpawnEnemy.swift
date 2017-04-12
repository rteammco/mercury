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
      
      // Create the enemy.
      let xSpawnPoint: CGFloat = Util.getUniformRandomValue(between: -0.75, and: 0.75)
      let ySpawnPoint: CGFloat = 1.0
      let enemy = Enemy(position: gameScene.getScaledPosition(CGPoint(x: xSpawnPoint, y: ySpawnPoint)), gameState: gameState, speed: 0.05)
      
      // Spawn it using the GameScene.
      gameScene.addGameObject(enemy, withPhysicsScaling: true)
      enemy.startMovement()
      
      // Inform the GameState of the change and update the global game state by incrementing the enemy spawn count value.
      gameState.inform(.spawnEnemy, value: enemy)
      let numEnemiesSpawned = gameState.getInt(forKey: .numSpawnedEnemies)
      gameState.set(.numSpawnedEnemies, to: numEnemiesSpawned + 1)
    }
  }
  
}
