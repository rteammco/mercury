//
//  GameScene.swift
//  Mercury
//
//  Created by Richard Teammco on 11/12/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The GameScene controlls all of the sprites, animations, and physics in the app. It also handles user touch inputs. The Level instance that's currently being run handles all of the game logic, and works closely with the GameScene for detecting sprite interactions.

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  // The active level (or menu).
  private var level: Level?
  
  // The size of the world (half of the average of the screen width and height).
  private var worldSize: Double?
  
  // The maximum and minumum x and y coordinates of the screen. This is used to determine if objects are within the screen.
  private var minimumScreenX: CGFloat?
  private var minimumScreenY: CGFloat?
  private var maximumScreenX: CGFloat?
  private var maximumScreenY: CGFloat?
  
  // The time of the last frame. The time elapsed between frames is the new time minus this time.
  private var lastFrameTime: TimeInterval?
  
  // If set, this indicates the first and most recent touch positions.
  private var lastTouchPosition: CGPoint?
  
  // Called whenever the scene is presented into the view.
  override func didMove(to view: SKView) {
    // TODO: this should create the appropriate level, not the general level.
    self.level = Level(gameScene: self)
    
    self.worldSize = Double(self.size.width + self.size.height) / 4.0
    
    let halfScreenWidth = self.size.width / 2
    let halfScreenHeight = self.size.height / 2
    self.minimumScreenX = -halfScreenWidth
    self.maximumScreenX = halfScreenWidth
    self.minimumScreenY = -halfScreenHeight
    self.maximumScreenY = halfScreenHeight
  }
  
  // Adds the given GameObject type to the scene by appending its node. In addition, scales the movement speed of the GameObject by the world size to account for the size of the device screen.
  func addGameObject(gameObject: GameObject) {
    if let worldSize = self.worldSize {
      gameObject.scaleMovementSpeed(worldSize)
    }
    gameObject.gameScene = self
    self.addChild(gameObject.getSceneNode())
  }
  
  // Returns true if the given object is within screen bounds.
  func isGameObjectWithinScreenBounds(gameObject: GameObject) -> Bool {
    let position = gameObject.getSceneNode().position
    if let minX = self.minimumScreenX, let maxX = self.maximumScreenX, let minY = self.minimumScreenY, let maxY = self.maximumScreenY {
      if position.x < minX || position.x > maxX || position.y < minY || position.y > maxY {
        return false
      }
    }
    return true
  }
  
  // Returns the previous position on the screen that a user's touch occured.
  // The previous location is the one before the latest touch action. If no touch was previously recorded, returns (0, 0) which is the center of the screen.
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
  
  // This method measures the elapsed time since the last frame and updates the current game level.
  // Called before each frame is rendered with the current time.
  override func update(_ currentTime: TimeInterval) {
    if let lastFrameTime = self.lastFrameTime {
      let elapsedTime = currentTime - lastFrameTime
      level?.update(elapsedTime)
    }
    self.lastFrameTime = currentTime
  }
  
}
