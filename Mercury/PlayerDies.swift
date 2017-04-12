//
//  PlayerDies.swift
//  Mercury
//
//  Created by Richard Teammco on 4/7/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An event that is triggered if the player dies.

import SpriteKit

class PlayerDies: Event {
  
  // Subscribe to the "player dies" game state event.
  override func start() {
    if let gameScene = self.caller {
      let gameState = gameScene.getGameState()
      subscribeTo(stateChanges: .playerDied, from: gameState)
    }
  }
  
  // When the "player dies" game state event occurs, trigger this event.
  override func reportStateChange(key: GameStateKey, value: Any) {
    if key == .playerDied {
      trigger()
    }
  }
  
}
