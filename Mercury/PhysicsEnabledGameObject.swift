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
  
  // TODO
  func createPhysicsBody() {
    // TODO
  }
  
  func applyImpulse(dx: CGFloat, dy: CGFloat) {
    self.gameSceneNode?.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
  }
  
}
