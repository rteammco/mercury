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
      
      // Create the enemy and spawn it using the GameScene.
      let xSpawnPos: CGFloat = Util.getUniformRandomValue(between: -1.0, and: 1.0)
      let ySpawnPos: CGFloat = 2.0
      let spawnPoint = gameScene.getScaledPosition(CGPoint(x: xSpawnPos, y: ySpawnPos))
      let enemy = Enemy(position: spawnPoint, gameState: gameState, speed: 0.05)
      gameScene.addGameObject(enemy, withPhysicsScaling: true)
      
      // Create a path for it so that it moves to a random target position.
      let xTargetPos: CGFloat = Util.getUniformRandomValue(between: -0.75, and: 0.75)
      let yTargetPos: CGFloat = Util.getUniformRandomValue(between: 0.15, and: 0.5)
      let targetPosition = gameScene.getScaledPosition(CGPoint(x: xTargetPos, y: yTargetPos))
      let path = GameObjectPath(from: spawnPoint, to: targetPosition)
      path.run(on: enemy, withSpeed: gameScene.getScaledValue(0.1))
      
      // Inform the GameState of the change and update the global game state by incrementing the enemy spawn count value.
      gameState.inform(.spawnEnemy, value: enemy)
      let numEnemiesSpawned = gameState.getInt(forKey: .numSpawnedEnemies)
      gameState.set(.numSpawnedEnemies, to: numEnemiesSpawned + 1)
    }
  }
  
}
