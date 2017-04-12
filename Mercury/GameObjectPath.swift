//
//  GameObjectPath.swift
//  Mercury
//
//  Created by Richard Teammco on 4/12/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  Provides functionality for scripting and randomizing game object movement paths.

import SpriteKit

class GameObjectPath {
  
  let path: UIBezierPath
  
  init(from startPoint: CGPoint, to endPoint: CGPoint) {
    self.path = UIBezierPath()
    self.path.move(to: startPoint)
    self.path.addQuadCurve(to: endPoint, controlPoint: CGPoint(x: startPoint.x, y: endPoint.y))
  }
  
  init(randomPathArea: CGRect, withNumStopPoints numStopPoints: Int, loop: Bool = false) {
    self.path = UIBezierPath()
    // TODO: Implement.
  }
  
  init(on targetObject: GameObject, withScale worldScale: CGFloat) {
    self.path = UIBezierPath()
    // TODO: Implement.
  }
  
  // Run the pathing animation on the given target GameObject and at the given speed.
  func run(on targetObject: GameObject, withSpeed speed: CGFloat, reorientToPath: Bool = false) {
    let motionAction = SKAction.follow(self.path.cgPath, asOffset: false, orientToPath: reorientToPath, speed: speed)
    targetObject.gameSceneNode?.run(motionAction)
  }
  
}
