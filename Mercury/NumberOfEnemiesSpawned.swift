//
//  NumberOfEnemiesSpawned.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

class NumberOfEnemiesSpawned: EventStopCriteria {
  
  let numberOfEnemies: Int
  
  var tempCounter: Int
  
  init(equals count: Int) {
    self.numberOfEnemies = count
    tempCounter = 0
  }
  
  override func isSatisfied() -> Bool {
    // TODO: actually add this in:
    //if let gameScene = self.caller as? GameScene {
    //  let gameState = gameScene.getGameState()
    //  let count = gameState.get(valueForKey: "number of enemies dead") as! Int
    //  return count >= self.numberOfEnemies
    //}
    tempCounter = tempCounter + 1
    return tempCounter >= 10  // TODO: temporary.
  }
  
}
