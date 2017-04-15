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
    createPlayer(atPosition: CGPoint(x: 0.0, y: -1.0))
    createGUI()
    
    // TODO: The loot values should be aquired from the GameState or something.
    let lootPackage = LootPackage()
    lootPackage.setExperieceReward(to: 10)
    lootPackage.setHealthReward(to: 50, withDropRate: 1)
    when(EnemyDies()).execute(action: CreateLootPackage(lootPackage: lootPackage))
    
    let phase1 = createEventPhase()
    phase1.execute(action: SpawnEnemy("test"))
    phase1.when(EnemyDies()).execute(action: SpawnEnemy("test")).until(NumberOfEnemiesSpawned(equals: 100)).then(DisplayText("You Did It!!"))
    
    let phase2 = createEventPhase()
    phase2.when(TimerFires(afterSeconds: 3)).execute(action: DisplayText("PHASE 2")).then(when: TimerFires(afterSeconds: 3)).execute(action: DisplayText("DONE"))
    
    setPhaseSequence(phase1, phase2)
    start(withCountdown: 3)
  }
  
  override func reportStateChange(key: GameStateKey, value: Any) {
    super.reportStateChange(key: key, value: value)
  }
  
}
