//
//  BasicEnemyPath.swift
//  Mercury
//
//  Created by Richard Teammco on 4/15/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A random path

import SpriteKit

class RandomEnemyPath: GameObjectPath {
  
  // Default boundary region where the enemy can end up.
  // TODO: Use global world scaling.
  static let defaultBoundary: CGRect = CGRect(x: -0.5, y: 0.25, width: 1.0, height: 0.25)

  // The speed with which this enemy will be moving through the scene.
  static let speed: CGFloat = GameConfiguration.mediumSpeed
  let scaledSpeed: CGFloat
  
  // Returns random paths for the given number of enemies in such a way that the random paths do not intersect.
  static func getMultiplePaths(inScene gameScene: GameScene, forNumEnemies count: Int, withinBoundary boundary: CGRect = RandomEnemyPath.defaultBoundary) -> [RandomEnemyPath] {
    var paths = [RandomEnemyPath]()
    let regionWidthPerEnemy = boundary.width / CGFloat(count)
    for i in 0 ..< count {
      let nextX = boundary.minX + (CGFloat(i) * regionWidthPerEnemy)
      let subBoundary = CGRect(x: nextX, y: boundary.minY, width: regionWidthPerEnemy, height: boundary.height)
      paths.append(RandomEnemyPath(inScene: gameScene, withinBoundary: subBoundary))
    }
    return paths
  }
  
  // Create the path. The GameScene is required to determine appropriate value scaling.
  init(inScene gameScene: GameScene, withinBoundary boundary: CGRect = RandomEnemyPath.defaultBoundary) {
    self.scaledSpeed = gameScene.getScaledValue(RandomEnemyPath.speed)
    
    // Create a random (scaled) target position based on the given boundary.
    let targetPosition = Util.getRandomPointInRectangle(boundary)
    let scaledTargetPosition = gameScene.getScaledPosition(targetPosition)
    
    // Create a random (scaled) spawn position.
    let xSpawnPos: CGFloat = Util.getUniformRandomValue(between: targetPosition.x - 0.25, and: targetPosition.x + 0.25)  // TODO: Use global world scaling.
    let ySpawnPos: CGFloat = 1.5  // TODO: Use global world scaling with "above screen" option.
    let scaledSpawnPoint = gameScene.getScaledPosition(CGPoint(x: xSpawnPos, y: ySpawnPos))
    
    // Create the path.
    super.init(from: scaledSpawnPoint, to: scaledTargetPosition)
  }
  
  // Run this path on the given enemy.
  func run(on enemy: Enemy) {
    super.run(on: enemy, withSpeed: self.scaledSpeed)
  }
  
}
