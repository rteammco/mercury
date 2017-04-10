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
  
  static func runExplosionEffect(on gameObject: GameObject) {
    
//    // TODO REMOVE AND FIX
//    let node = SKShapeNode(rectOf: CGSize.init(width: 50, height: 50))
//    node.position = CGPoint(x: 0, y: 0)
//    //node.alpha = 0.0
//    if let emitter = SKEmitterNode(fileNamed: "ImpactExplosion.sks") {
//      emitter.position = CGPoint(x: 0, y: 0)
//      emitter.name = "explosion"
//      //emitter.alpha = 1.0
//      //emitter.isHidden = false
//      //emitter.targetNode = self
//      node.addChild(emitter)
//    }
//    addChild(node)
//    if let emitter = SKEmitterNode(fileNamed: "ImpactExplosion.sks") {
//      if let scene = gameObject.gameSceneNode?.scene {
//      emitter.position = gameObject.getPosition()
//      emitter.name = "explosion"
//      emitter.targetNode = scene
//      emitter.zPosition = 2
//      //let effectNode = SKEffectNode()
//      //effectNode.addChild(emitter)
//      //effectNode.zPosition = 0
//      scene.addChild(emitter)
//      /*
//       emitter.position = CGPointMake(posX,posy);
//       emitter.name = @"explosion";
//       emitter.targetNode = self.scene;
//       emitter.numParticlesToEmit = 1000;
//       emitter.zPosition=2.0;
// */
//        print("NODE ADDED")
//        
//      }
      //ParticleSystems.runEffect(emitter, on: gameObject, atOffset: CGPoint(x: 0, y: 0), forDuration: 0.1)
    }
  }
  
}
