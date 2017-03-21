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
  
  // Subscribe to the "enemy dies" game state event.
  override func start() {
    if let gameScene = self.caller as? GameScene {
      let gameState = gameScene.getGameState()
      gameState.subscribe(self, to: .enemyDies)
    }
  }
  
  // When the "enemy dies" game state event occurs, trigger this event.
  override func reportStateChange(key: GameStateKey, value: Any) {
    if key == .enemyDies {
      trigger()
    }
  }
  
}
