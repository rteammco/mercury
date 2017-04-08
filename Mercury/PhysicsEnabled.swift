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
  func initializePhysics()
  
  // Applies an impulse force to the body. The magnitude of the given vector [dx, dy] determines the strength of the force and projects it in the direction of the vector.
  func applyImpulse(_ impulseVector: CGVector)
  
  // Sets the object's velocity to the given value. The magnitued of the given velocity vector determines the speed, regardless of the object's mass and other physical properties.
  func setVelocity(_ velocityVector: CGVector)
  
}
