//
//  GameScene.swift
//  Mercury
//
//  Created by Richard Teammco on 11/12/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  // The active level (or menu).
  private var level: Level?
  
  // The time of the last frame. The time elapsed between frames is the new time minus this time.
  private var lastFrameTime: TimeInterval?
  
  // If set, this indicates the first and most recent touch positions.
  private var lastTouchPosition: CGPoint?
  
  // Called whenever the scene is presented into the view.
  override func didMove(to view: SKView) {
    // TODO: this should create the appropriate level, not the general level.
    self.level = Level(gameScene: self)
  }
  
  // Adds the given GameObject type to the scene by appending its node.
  func addGameObject(gameObject: GameObject) {
    self.addChild(gameObject.getSceneNode())
  }
  
  // Returns the previous position on the screen that a user's touch occured. The previous location is the one before the latest touch action. If no touch was previously recorded, returns (0, 0) which is the center of the screen.
  func getPreviousTouchPosition() -> CGPoint {
    if let previousTouchPosition = self.lastTouchPosition {
      return previousTouchPosition
    } else {
      return CGPoint(x: 0, y: 0)
    }
  }
  
  func touchDown(atPoint pos: CGPoint) {
    self.level?.touchDown(atPoint: pos)
    self.lastTouchPosition = pos
  }
  
  func touchMoved(toPoint pos: CGPoint) {
    self.level?.touchMoved(toPoint: pos)
    self.lastTouchPosition = pos
  }
  
  func touchUp(atPoint pos: CGPoint) {
    self.level?.touchUp(atPoint: pos)
  }
  
  // Called when user starts a touch action.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  // Called when user moves (drags) during a touch action.
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  // Called when user finishes a touch action.
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  // Called when a touch action is interrupted or otherwise cancelled.
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  // Called before each frame is rendered with the current time. This measures the elapsed time since the last frame and updates the current game level.
  override func update(_ currentTime: TimeInterval) {
    if let lastFrameTime = self.lastFrameTime {
      let elapsedTime = currentTime - lastFrameTime
      level?.update(elapsedTime)
    }
    self.lastFrameTime = currentTime
  }
  
}
