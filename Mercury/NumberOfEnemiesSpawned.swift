//
//  NumberOfEnemiesSpawned.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

class NumberOfEnemiesSpawned: EventStopper {
  
  let numberOfEnemies: Int
  
  init(equals count: Int) {
    self.numberOfEnemies = count
  }
  
  override func isSatisfied() -> Bool {
    if let gameScene = self.caller as? GameScene {
      let gameState = gameScene.getGameState()
      let count = gameState.getInt(forKey: GameStateKey.numSpawnedEnemies)
      return count >= self.numberOfEnemies
    }
    return false
  }
  
}
