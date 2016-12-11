//
//  PhysicsEnabled.swift
//  Mercury
//
//  Created by Richard Teammco on 12/11/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  Protocol to extend a GameObject with physics properties.

import SpriteKit

protocol PhysicsEnabled {
  
  // Create the physics body of the object, including its physical shape and all of its physical properties. This must be called before any physical interactions with the object can be processed.
  func createPhysicsBody()
  
  // Applies an impulse force to the body. The magnitude of the given vector [dx, dy] determines the strength of the force and projects it in the direction of the vector.
  // This can be used to start projectiles' motion.
  func applyImpulse(dx: CGFloat, dy: CGFloat)
  
}
