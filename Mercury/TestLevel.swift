//
//  TestLevel.swift
//  Mercury
//
//  Created by Richard Teammco on 1/13/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

import SpriteKit

class TestLevel: GameScene {
    
  override func initializeScene() {
    createPlayer(atPosition: CGPoint(x: 0.0, y: -1.0))
  /*
     // TODO: use events to build the level, e.g. like this:
     
     createPlayer(position)
     
     // create the scripted events
     
     when(EnemyDies()).do(AwardPlayerPoints(10), Spawn(TEST_LEVEL_BASIC_ENEMY)).until(NumberOfEnemiesDead(equals: 10))
     when(NumberOfEnemiesDead(equals: 10)).do(Spawn(TEST_LEVEL_BOSS_1)).then(MakeImmune())
     when(Spawned(TEST_LEVEL_BOSS_1)).do(ShakeScreen(seconds: 5)).then(StartEvent()).then(MakeNotImmune())
     
     bindSpawnMethod(TEST_LEVEL_BASIC_ENEMY, spawnEnemy)
     bindSpawnMethod(TEST_LEVEL_BOSS_1, spawnBoss)
     
     countdown(5)
   */
  }
  
  func spawnEnemy() {
    // Create a new enemy
  }
 
  func spawnBoss() {
    /*
     boss = TestLevelBoss()
     when(boss, Dies()).do(EndEvent()).then(AwardPlayerXP(1000), AwardPlayerPoints(100), FinishLevel())
     boss.when(Dies()).do(EndEvent()).then(AwardPlayerXP(1000), AwardPlayerPoints(100), FinishLevel())
     */
  }
}
