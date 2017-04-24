//
//  EnemyDies.swift
//  Mercury
//
//  Created by Richard Teammco on 3/21/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An event that is triggered whenever an enemy dies.

import SpriteKit

class EnemyDies: Event {
  
  let numEnemiesToDie: Int
  var numEnemiesDied: Int
  
  // Triggered when the given number of enemies die.
  init(count: Int = 1) {
    self.numEnemiesToDie = count
    self.numEnemiesDied = 0
  }
  
  // Subscribe to the "enemy dies" game state event.
  override func start() {
    super.start()
    self.numEnemiesDied = 0
    subscribeTo(stateChanges: .enemyDied)
  }
  
  // When the "enemy dies" game state event occurs, trigger this event.
  override func reportStateChange(key: GameStateKey, value: Any) {
    if key == .enemyDied {
      self.numEnemiesDied += 1
      if self.numEnemiesDied >= self.numEnemiesToDie {
        trigger(withOptionalValue: value)  // value here should be the Enemy object that died.
      }
    }
  }
  
}
