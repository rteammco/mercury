//
//  ParticleSystems.swift
//  Mercury
//
//  Created by Richard Teammco on 4/8/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  Contains a set of functions that handle creating and running particle effects.

import SpriteKit

struct ParticleSystems {
  
  // Starts running the given effect for the given duration. After the duration runs out, the effect will automatically remove itself from its parent node or scene.
  // A negative duration is invalid and will do nothing (i.e. the effect will run forever).
  private static func runEffect(_ emitter: SKEmitterNode, forDuration duration: TimeInterval) {
    if duration < 0 {
      return
    }
    let wait = SKAction.wait(forDuration: duration)
    let removeEffect = SKAction.run({
      () in emitter.removeFromParent()
    })
    emitter.run(SKAction.sequence([wait, removeEffect]))
  }
  
  // Runs the given particle effects emitter on the given object. The offset position will be the location on the object's node where the effect will be positioned. The given duration will be how long the effect will last.
  private static func runEffect(_ emitter: SKEmitterNode, on parentNode: SKNode, atOffset relativePosition: CGPoint, forDuration duration: TimeInterval) {
    emitter.position = relativePosition
    parentNode.addChild(emitter)
    runEffect(emitter, forDuration: duration)
  }
  
  // Runs a specific bullet impact effect that will create a small "spark" effect at the bullet's impact location. This spark effect will be oriented in the reverse orientation of the bullet's trajectory.
  static func runBulletImpactEffect(bullet: Bullet, target: GameObject) {
    if let emitter = SKEmitterNode(fileNamed: "ImpactSpark.sks"), let parentNode = target.gameSceneNode {
      if let bulletNode = bullet.gameSceneNode {
        emitter.emissionAngle = bulletNode.zRotation + CGFloat.pi
      }
      let bulletPosition = bullet.getPosition()
      let targetPosition = target.getPosition()
      let positionOffset = CGPoint(x: bulletPosition.x - targetPosition.x, y: bulletPosition.y - targetPosition.y)
      runEffect(emitter, on: parentNode, atOffset: positionOffset, forDuration: 0.1)
    }
  }
  
  // Runs an explosion effect at the given object's location. This effect is not tied to the given object, but rather simulates it exploading in a separate animation.
  static func runExplosionEffect(on gameObject: GameObject) {
    if let emitter = SKEmitterNode(fileNamed: "ImpactExplosion.sks") {
      emitter.position = gameObject.getPosition()
      emitter.numParticlesToEmit = 1000
      runEffect(emitter, forDuration: 2.0)
      gameObject.gameState.inform(.createParticleEffect, value: emitter)
    }
  }
  
}
