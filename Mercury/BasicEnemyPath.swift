//
//  BasicEnemyPath.swift
//  Mercury
//
//  Created by Richard Teammco on 4/15/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

import SpriteKit

class BasicEnemyPath: GameObjectPath {
  
  // The speed with which this enemy will be moving through the scene.
  static let speed: CGFloat = 0.5
  let scaledSpeed: CGFloat
  
  // Create the path. The GameScene is required to determine appropriate value scaling.
  init(inScene gameScene: GameScene) {
    self.scaledSpeed = gameScene.getScaledValue(BasicEnemyPath.speed)
    // Create a random (scaled) spawn position.
    let xSpawnPos: CGFloat = Util.getUniformRandomValue(between: -1.0, and: 1.0)
    let ySpawnPos: CGFloat = 2.0
    let spawnPoint = gameScene.getScaledPosition(CGPoint(x: xSpawnPos, y: ySpawnPos))
    // Create a random (scaled) target position.
    let xTargetPos: CGFloat = Util.getUniformRandomValue(between: -0.75, and: 0.75)
    let yTargetPos: CGFloat = Util.getUniformRandomValue(between: 0.15, and: 0.5)
    let targetPosition = gameScene.getScaledPosition(CGPoint(x: xTargetPos, y: yTargetPos))
    // Create the path.
    super.init(from: spawnPoint, to: targetPosition)
  }
  
  // Run this path on the given enemy.
  func run(on enemy: Enemy) {
    super.run(on: enemy, withSpeed: self.scaledSpeed)
  }
  
}
