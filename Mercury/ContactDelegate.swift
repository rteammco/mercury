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
    // Don't do physics if either object was previously destroyed.
    guard !objectA.wasDestroyed && !objectB.wasDestroyed else {
      return
    }
    
    // If either object is a Bullet, handle bullet-object collision.
    if objectA is Bullet {
      handleBulletCollision(bullet: objectA as! Bullet, target: objectB)
    } else if objectB is Bullet {
      handleBulletCollision(bullet: objectB as! Bullet, target: objectA)
      
    // If one object is a LootItem and the other is the Player, handle the loot-player collision.
    } else if objectA is LootItem, objectB is Player {
      handleLootItemCollision(lootItem: objectA as! LootItem)
    } else if objectB is LootItem, objectA is Player {
      handleLootItemCollision(lootItem: objectB as! LootItem)
      
      // Otherwise, if one of the objects is the Player, handle player-object collision.
    } else if objectA is Player {
      handlePlayerCollision(player: objectA as! Player, collidedWith: objectB)
    } else if objectB is Player {
      handlePlayerCollision(player: objectB as! Player, collidedWith: objectA)
    }
  }
  
  // Handles the scenario where a bullet hit another object in the scene.
  private func handleBulletCollision(bullet: Bullet, target: GameObject) {
    ParticleSystems.runBulletImpactEffect(bullet: bullet, target: target)
    target.changeHitPoints(by: -bullet.getHitDamage())
    bullet.removeSceneNodeFromGameScene()
  }
  
  private func handleLootItemCollision(lootItem: LootItem) {
    lootItem.applyReward()
    lootItem.destroyObject()
  }
  
  private func handlePlayerCollision(player: Player, collidedWith otherObject: GameObject) {
    player.changeHitPoints(by: -otherObject.getMaxHitPoints())
    otherObject.destroyObject()
  }
  
}
