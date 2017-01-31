//
//  SpawnBasicEnemy.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An EventAction that spawns the enemy of the given name when triggered.

class SpawnEnemy: EventAction {
  
  // TODO: location, and actually switch between the appropriate enemies.
  init(_ enemyName: String) {
    
  }

  override func execute() {
    if let gameScene = self.caller as? GameScene {
      gameScene.displayTextOnScreen(message: "Spawning an enemy")  // TODO: change.
    }
  }
  
}
