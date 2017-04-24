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
  
  // When two or more enemies are spawned, the method will dictate how they are positioned.
  enum MultipleEnemyPositioning {
    case random  // The enemies will be spawned at and will move to random locations, but they will not be on top of each other.
    case clustered  // The enemies will tend to be clustered in the same location.
    case line  // The enemies will line up in a horizontal row (across the y axis).
    case formation  // The enemies will group in a triangular formation pattern.
  }
  
  // The enemy type, count, and positioning.
  let enemyName: String
  let numEnemiesToSpawn: Int
  let enemyPositioning: MultipleEnemyPositioning
  
  // Spawn an enemy of the given name.
  // If count > 1, that is the number of enemies that will be spawned.
  init(_ enemyName: String, count: Int = 1, withPositioning positioning: MultipleEnemyPositioning = .random) {
    self.enemyName = enemyName
    self.numEnemiesToSpawn = count
    self.enemyPositioning = positioning
  }

  override func execute(withOptionalValue optionalValue: Any? = nil) {
    // TODO: Switch between the appropriate enemies.
    if let gameScene = self.caller {
      
      // TODO: Implement support for all positioning methods: random, clustered, line, formation.
      
      for _ in 1...numEnemiesToSpawn {
        // Create the enemy and spawn it using the GameScene.
        let enemy = Enemy(position: SpawnEnemy.defaultSpawnLocation)
        gameScene.addGameObject(enemy, withPhysicsScaling: true)
        // Make a path for the enemy.
        let enemyPath = BasicEnemyPath(inScene: gameScene)
        enemyPath.run(on: enemy)
      
        // Inform the GameState of the change and update the global game state by incrementing the enemy spawn count value.
        GameScene.gameState.inform(.spawnEnemy, value: enemy)
        let numEnemiesSpawned = GameScene.gameState.getInt(forKey: .numSpawnedEnemies)
        GameScene.gameState.set(.numSpawnedEnemies, to: numEnemiesSpawned + 1)
      }
    }
  }
  
}
