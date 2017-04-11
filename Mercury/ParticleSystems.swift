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
  
  // Runs the given particle effects emitter on the given object. The offset position will be the location on the object's node where the effect will be positioned. The given duration will be how long the effect will last.
  static func runEffect(_ emitter: SKEmitterNode, on parentNode: SKNode, atOffset relativePosition: CGPoint, forDuration duration: TimeInterval) {
    let effectNode = SKEffectNode()
    effectNode.position = relativePosition
    effectNode.addChild(emitter)
    effectNode.zPosition = 0
    let addEffect = SKAction.run({
      () in parentNode.addChild(effectNode)
    })
    let wait = SKAction.wait(forDuration: duration)
    let removeEffect = SKAction.run({
      () in effectNode.removeFromParent()
    })
    parentNode.run(SKAction.sequence([addEffect, wait, removeEffect]))
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
  
  static func runExplosionEffect(on gameObject: GameObject) {
    if let emitter = SKEmitterNode(fileNamed: "ImpactExplosion.sks") {
      let effectNode = SKEffectNode()
      effectNode.position = gameObject.getPosition()
      effectNode.addChild(emitter)
      effectNode.zPosition = 0
      effectNode.name = "explosion"
      // TODO: gameObject.gameState.inform(.createEffectsNode, node)
    }
  }
  
}
