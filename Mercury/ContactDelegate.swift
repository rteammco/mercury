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
    // TODO
  }
  
}
