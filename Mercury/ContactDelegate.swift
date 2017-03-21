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
  
  func didBegin(_ contact: SKPhysicsContact) {
    let nodeA = contact.bodyA.node
    let nodeB = contact.bodyB.node
    if let objectA: GameObject = nodeA?.userData?.value(forKey: GameObject.nodeValueKey) as? GameObject, let objectB: GameObject = nodeB?.userData?.value(forKey: GameObject.nodeValueKey) as? GameObject {
      // TODO: actually handle the collision logic here.
      print(objectA.nodeName, "collided with", objectB.nodeName)
    }
  }
  
}
