//
//  CollisionBitMasks.swift
//  Mercury
//
//  Created by Richard Teammco on 3/21/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A list of physics collision bitmasks used by the physics engine to detect collision events. Each bitmask is associated with a particular category of object.
//  The physics ContactDelegate detects contact between scene nodes that define the appropriate contact bitmasks.
//  For example, a node's category can be set as "friendly" and its collision test categories can set to "enemy" and "environment". This means the physics engine will determine collisions between our node and any other node whose category is either "enemy" or "environment". Furthermore, any other node that has "friendly" as one of its collision test categories will be able to collide with this node as well.

struct PhysicsCollisionBitMask {
  
  static let none: UInt32                     = 0

  // "friendly" is absolute in terms of the player. "enemy" is for all enemies of the player.
  static let friendly: UInt32                       = 0x1 << 1  // TODO: Rename to "player" instead of "friendly".
  static let enemy: UInt32                          = 0x1 << 2
  static let environment: UInt32                    = 0x1 << 3
  static let item: UInt32                           = 0x1 << 4
  
  // Projectiles are special case objects that can interact with other types, but not with each other. For example, bullets cannot collide with other bullets.
  static let projectile: UInt32                     = 0x1 << 5
  
  // All bits are 1, so it can interact with any other object.
  static let anyObject: UInt32                      = UInt32.max
  
}
