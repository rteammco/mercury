//
//  ContactDelegate.swift
//  Mercury
//
//  Created by Richard Teammco on 12/11/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  Handles contact (collision) processing of physics interactions in the GameScene.

import SpriteKit

// Have to use NSObject base class because SKPhysicsContactDelegate requires conforming to NSObjectProtocol (Objective-C object).
class ContactDelegate: NSObject, SKPhysicsContactDelegate {

  // This method gets called by the physics engine whenever a collision starts.
  func didBegin(_ contact: SKPhysicsContact) {
    let nodeA = contact.bodyA.node
    let nodeB = contact.bodyB.node
    if let objectA: GameObject = nodeA?.userData?.value(forKey: GameObject.nodeValueKey) as? GameObject, let objectB: GameObject = nodeB?.userData?.value(forKey: GameObject.nodeValueKey) as? GameObject {
      processCollisionEvent(objectA: objectA, objectB: objectB)
    }
  }
  
  // Given two objects that collide, this method figures out how the collision should be handled.
  private func processCollisionEvent(objectA: GameObject, objectB: GameObject) {
    if objectA is Bullet {
      handleBulletCollision(bullet: objectA as! Bullet, target: objectB)
    } else if objectB is Bullet {
      handleBulletCollision(bullet: objectB as! Bullet, target: objectA)
    }
  }
  
  // Handles the scenario where a bullet hit another object in the scene.
  private func handleBulletCollision(bullet: Bullet, target: GameObject) {
    target.reduceHeath(by: bullet.getHitDamage())
    bullet.removeSceneNodeFromGameScene()
  }
  
}
