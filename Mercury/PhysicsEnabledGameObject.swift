//
//  PhysicsEnabledGameObject.swift
//  Mercury
//
//  Created by Richard Teammco on 12/11/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//

import SpriteKit

class PhysicsEnabledGameObject: GameObject, PhysicsEnabled {

  // TODO: self.gameSceneNode?.physicsBody?.categoryBitMask ...?
  
  // Physical attributes of this object. Modify in child class as needed.
  var physicsFriction: CGFloat = 0.0  // The amount of resistance applied to other objects that touch this one's surface.
  
  var physicsMass: CGFloat = 0.0  // Determines how forces act on the object as well as momentum; 0.0 = forces control it completely and immediately.
  
  var physicsRestitution: CGFloat = 1.0  // How much energy is preserved on collision (i.e. "bounciness"); 1.0 = all energy is maintained.
  
  var physicsLinearDamping: CGFloat = 0.0  // Movement friction as object moves through the world (e.g. to simulate friction due to air).
  
  var physicsAngularDamping: CGFloat = 0.0  // Same but for angular friction.
  
  var physicsAllowsRotation: Bool = false  // true = forces can impact angular velocity.
  
  var physicsIsDynamic: Bool = true  // true = this object is simulated by the physics subsystem; false = only acts on other objects (e.g. user-controlled objects).
  
  // Adjust the mass of the object to fit the world's scale, or whatever scale is given.
  // This is just like GameObject's scaleMovementSpeed method specifically for objects with physical mass that use this mass to interact with the simulated physics.
  // Objects should define their mass on a normalized scale (e.g. 0 to 1, or more than 1 for very heavy objects). Then before the object is added to the game, scale its mass by the scale of the world.
  func scaleMass(by scaleAmount: CGFloat) {
    self.physicsMass *= scaleAmount
  }
  
  // Returns a physics body that represents this object's shape. This is used to compute collisions and interaction with other physics-enabled objects.
  // By default, the physics body is just a circle around the object. This can be defined as an arbitrary polygon for more realistic physical simulations.
  // If the gameSceneNode is not defined, it will just return a single pixel-size circle.
  func getPhysicsBody() -> SKPhysicsBody {
    if let gameSceneNode = self.gameSceneNode {
      return SKPhysicsBody(circleOfRadius: gameSceneNode.frame.size.width / 2)
    }
    return SKPhysicsBody(circleOfRadius: 1.0)
  }
  
  // Creates a circular physics body (the most basic collision check) with the physical properties as they are defined in the object's variables (set specifically for each object).
  // This should be called before adding the node to the game, ideally in createGameSceneNode().
  func initializePhysics() {
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.physicsBody = getPhysicsBody()
      gameSceneNode.physicsBody?.friction = self.physicsFriction
      gameSceneNode.physicsBody?.mass = self.physicsMass
      gameSceneNode.physicsBody?.restitution = self.physicsRestitution
      gameSceneNode.physicsBody?.linearDamping = self.physicsLinearDamping
      gameSceneNode.physicsBody?.angularDamping = self.physicsAngularDamping
      gameSceneNode.physicsBody?.allowsRotation = self.physicsAllowsRotation
      gameSceneNode.physicsBody?.isDynamic = self.physicsIsDynamic
    }
  }
  
  // Applies a one-time physical impulse to the object. The strength of the "bump" is determined by the given vector, and the reaction depends on the object's physical properties.
  func applyImpulse(dx: CGFloat, dy: CGFloat) {
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    } else {
      print("WARNING: gameSceneNode has not been initialized. No impulse can be applied.")
    }
  }
  
  // Sets the velocity of the object to the given value, regardless of the object's current physical properties.
  func setVelocity(xVelocity: CGFloat, yVelocity: CGFloat) {
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.physicsBody?.velocity = CGVector(dx: xVelocity, dy: yVelocity)
    } else {
      print("WARNING: gameSceneNode has not been initialized. Velocity cannot be set.")
    }
  }
  
  // Sets the current velocity to the movement speed and direction of the GameObject.
  func setDefaultVelocity() {
    let dx = self.movementDirection.dx * self.movementSpeed
    let dy = self.movementDirection.dy * self.movementSpeed
    setVelocity(xVelocity: dx, yVelocity: dy)
  }
  
}
