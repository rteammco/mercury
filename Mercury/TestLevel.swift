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
    
    // Need to call this to handle any state changes that are triggered by other objects.
    self.subscribeToStateChanges()
    
    //when(TimerEvent(seconds: 5)).execute(action: DisplayText(message: "Hello, World"))
    //when(TimerEvent(seconds: 1)).execute(action: SpawnEnemy("test")).until(NumberOfEnemiesSpawned(equals: 10))
    
    let phase1 = createEventPhase()
    phase1.when(EnemyDies()).execute(actions: SpawnEnemy("test"), DisplayText(message: "Enemy Died!")).until(NumberOfEnemiesSpawned(equals: 10)).then(DisplayText(message: "You Did It!!"))
    phase1.execute(action: SpawnEnemy("test"))
    
    let phase2 = createEventPhase()
    phase2.when(TimerEvent(seconds: 3)).execute(action: DisplayText(message: "PHASE 2"))
    
    setPhaseSequence(phase1, phase2)
    
    //let phase1 = createPhase()
    //phase1.when(...)
    //phase1.execute(...)
    //let phase2 = GamePhase()
    //...
    //run(phase1, phase2)
    
  /*
     // TODO: use events to build the level, e.g. like this:
     
     // create the scripted events
     when(player, IsTouched()).execute(action: PlayerShoot())
     
     when(EnemyDies()).execute(actions: AwardPlayerPoints(10), Spawn(TEST_LEVEL_BASIC_ENEMY)).until(NumberOfEnemiesDead(equals: 10))
     when(NumberOfEnemiesDead(equals: 10)).do(Spawn(TEST_LEVEL_BOSS_1)).then(MakeImmune())
     when(Spawned(TEST_LEVEL_BOSS_1)).do(ShakeScreen(seconds: 5)).then(StartEvent()).then(MakeNotImmune())
     
     bindSpawnMethod(TEST_LEVEL_BASIC_ENEMY, spawnEnemy)
     bindSpawnMethod(TEST_LEVEL_BOSS_1, spawnBoss)
     
     countdown(5)
   */
  }
  
  override func reportStateChange(key: GameStateKey, value: Any) {
    super.reportStateChange(key: key, value: value)
  }
  
}
