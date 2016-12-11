//
//  PhysicsEnabled.swift
//  Mercury
//
//  Created by Richard Teammco on 12/11/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  Protocol that extends a GameObject with physics properties.

import SpriteKit

protocol PhysicsEnabled {
  
  // TODO
  func createPhysicsBody()
  
  // TODO
  func applyImpulse(dx: CGFloat, dy: CGFloat)
  
}
