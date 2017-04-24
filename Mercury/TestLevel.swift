//
//  TestLevel.swift
//  Mercury
//
//  Created by Richard Teammco on 1/13/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A GameScene level used for testing new features adding to the game.

import SpriteKit

class TestLevel: GameScene {
    
  override func initializeScene() {
    super.initializeScene()
    createBackground()
    createPlayer(atPosition: CGPoint(x: 0.0, y: GameConfiguration.defaultPlayerSpawnYPosition))
    createGUI()
    
    // TODO: The loot values should be aquired from the GameState or something.
    let lootPackage = LootPackage()
    lootPackage.setExperieceReward(to: 5)
    lootPackage.setHealthReward(to: 50, withDropRate: 0.2)
    when(EnemyDies()).execute(action: CreateLootPackage(lootPackage: lootPackage))
    
    // Phase 1: 1 enemy at a time, 10 enemies total.
    let phase1 = createEventPhase()
    phase1.execute(action: DisplayText("Phase 1: 10x1"))
    phase1.execute(action: SpawnEnemy("test1"))
    phase1.when(EnemyDies())
      .execute(action: SpawnEnemy("test1"))
      .until(NumberOfEnemiesSpawned(equals: 10))
    
    // Phase 2: 2 enemies at a time, 20 enemies total. Player gets bonus XP per enemy pair.
    let phase2 = createEventPhase()
    let phase2Rewards = LootPackage()
    phase2Rewards.setExperieceReward(to: 20)
    phase2.execute(action: DisplayText("Phase 2: 20x2"))
    phase2.execute(action: SpawnEnemy("test2", count: 2))
    phase2.when(EnemyDies(count: 2))
      .execute(actions: SpawnEnemy("test2"), CreateLootPackage(lootPackage: phase2Rewards))
      .until(NumberOfEnemiesSpawned(equals: 20))
    
    // Phase 3: 3 enemies at a time, 30 enemies total. Player gets bonus XP per enemy set.
    let phase3 = createEventPhase()
    let phase3Rewards = LootPackage()
    phase3Rewards.setExperieceReward(to: 30)
    phase3.execute(action: DisplayText("Phase 3: 30x3"))
    phase3.execute(action: SpawnEnemy("test3", count: 3))
    phase3.when(EnemyDies(count: 3))
      .execute(actions: SpawnEnemy("test3", count: 3), CreateLootPackage(lootPackage: phase3Rewards))
      .until(NumberOfEnemiesSpawned(equals: 30))
    
    // Phase 4: 5 enemies at a time, 100 enemies total. Player gets bonus XP and health per enemy set.
    let phase4 = createEventPhase()
    let phase4Rewards = LootPackage()
    phase4Rewards.setExperieceReward(to: 50)
    phase4Rewards.setHealthReward(between: 100, and: 300)
    phase3.execute(action: DisplayText("Phase 4: 100x5"))
    phase3.execute(action: SpawnEnemy("test4", count: 5))
    phase3.when(EnemyDies(count: 5))
      .execute(actions: SpawnEnemy("test4", count: 5), CreateLootPackage(lootPackage: phase4Rewards))
    phase4.when(EnemyDies(count: 100))
      .execute(action: DisplayText("You Did It!!"))
    
    // Phase 5 is just text displays.
    let phase5 = createEventPhase()
    phase5.when(TimerFires(afterSeconds: 3))
      .execute(action: DisplayText("PHASE 2"))
      .then(when: TimerFires(afterSeconds: 3))
      .execute(action: DisplayText("DONE"))
    
    setPhaseSequence(phase1, phase2, phase3, phase4, phase5)
    start(withCountdown: 3)
  }
  
  override func reset() {
    super.reset()
    createBackground()
    createPlayer(atPosition: CGPoint(x: 0.0, y: GameConfiguration.defaultPlayerSpawnYPosition))
    createGUI()
  }
  
  override func reportStateChange(key: GameStateKey, value: Any) {
    super.reportStateChange(key: key, value: value)
  }
  
}
