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
    self.getGameState().subscribe(self, to: "player fire bullet")
    
    when(TimerEvent(seconds: 5)).execute(action: DisplayText(message: "Hello, World"))
    when(TimerEvent(seconds: 1)).execute(action: SpawnEnemy("test")).until(NumberOfEnemiesSpawned(equals: 10))
    //when(EnemyDies()).execute(action: SpawnEnemy("test")).until(NumberOfEnemiesSpawned(equals: 10))
    execute(action: SpawnEnemy("test"))
    
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
  
  override func reportStateChange(key: String, value: Any) {
    super.reportStateChange(key: key, value: value)
    if key == "player fire bullet" {
      if let playerPosition = value as? CGPoint {
        let bullet = Bullet(position: CGPoint(x: playerPosition.x, y: playerPosition.y), speed: getScaledValue(2.0))
        addGameObject(bullet)
        bullet.applyDefaultImpulse()
      }
    }
  }
}
