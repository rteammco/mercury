//
//  NumberOfEnemiesSpawned.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

class NumberOfEnemiesSpawned: EventStopper {
  
  let numberOfEnemies: Int
  
  var tempCounter: Int
  
  init(equals count: Int) {
    self.numberOfEnemies = count
    tempCounter = 0
  }
  
  override func isSatisfied() -> Bool {
    if let gameScene = self.caller as? GameScene {
      let gameState = gameScene.getGameState()
      let count = gameState.get(valueForKey: "enemy spawn count") as! Int
      print(count)
      return count >= self.numberOfEnemies
    }
    return false
  }
  
}
