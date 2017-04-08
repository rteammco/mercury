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
  static func runEffect(_ emitter: SKEmitterNode, on gameObject: GameObject, atOffset relativePosition: CGPoint, forDuration duration: TimeInterval) {
    let effectNode = SKEffectNode()
    effectNode.position = relativePosition
    effectNode.addChild(emitter)
    effectNode.zPosition = 0
    let addEffect = SKAction.run({
      () in gameObject.gameSceneNode?.addChild(effectNode)
    })
    let wait = SKAction.wait(forDuration: duration)
    let removeEffect = SKAction.run({
      () in effectNode.removeFromParent()
    })
    gameObject.gameSceneNode?.run(SKAction.sequence([addEffect, wait, removeEffect]))
  }
  
  // Runs a specific bullet impact effect that will create a small "spark" effect at the bullet's impact location. This spark effect will be oriented in the reverse orientation of the bullet's trajectory.
  static func runBulletImpactEffect(bullet: Bullet, target: GameObject) {
    if let emitter = SKEmitterNode(fileNamed: "ImpactSpark.sks") {
      if let bulletNode = bullet.gameSceneNode {
        emitter.emissionAngle = bulletNode.zRotation + CGFloat.pi
      }
      let bulletPosition = bullet.getPosition()
      let targetPosition = target.getPosition()
      let positionOffset = CGPoint(x: bulletPosition.x - targetPosition.x, y: bulletPosition.y - targetPosition.y)
      ParticleSystems.runEffect(emitter, on: target, atOffset: positionOffset, forDuration: 0.1)
    }
  }
  
}
