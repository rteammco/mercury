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
  
  // Run the pathing animation on the given target GameObject and at the given speed.
  func run(on targetObject: GameObject, withSpeed speed: CGFloat, reorientToPath: Bool = false) {
    let motionAction = SKAction.follow(self.path.cgPath, asOffset: false, orientToPath: reorientToPath, speed: speed)
    let alertFinished = SKAction.run({
      () in targetObject.notifyMotionEnded()
    })
    if let gameSceneNode = targetObject.gameSceneNode {
      gameSceneNode.run(SKAction.sequence([motionAction, alertFinished]))
      targetObject.notifyMotionStarted()
    }
  }
  
}
