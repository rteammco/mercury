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
  
  // Default spawn location, just the center of the screen.
  static let defaultSpawnLocation: CGPoint = CGPoint(x: 0, y: 0)
  
  let enemyName: String
  
  init(_ enemyName: String) {
    self.enemyName = enemyName
  }

  override func execute(withOptionalValue optionalValue: Any? = nil) {
    // TODO: Switch between the appropriate enemies.
    if let gameScene = self.caller {
      let gameState = gameScene.getGameState()
      
      // Create the enemy and spawn it using the GameScene.
      let enemy = Enemy(position: SpawnEnemy.defaultSpawnLocation, gameState: gameState)
      gameScene.addGameObject(enemy, withPhysicsScaling: true)
      // Make a path for the enemy.
      let enemyPath = BasicEnemyPath(inScene: gameScene)
      enemyPath.run(on: enemy)
      
      // Inform the GameState of the change and update the global game state by incrementing the enemy spawn count value.
      gameState.inform(.spawnEnemy, value: enemy)
      let numEnemiesSpawned = gameState.getInt(forKey: .numSpawnedEnemies)
      gameState.set(.numSpawnedEnemies, to: numEnemiesSpawned + 1)
    }
  }
  
}
