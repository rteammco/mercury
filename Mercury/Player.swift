//
//  Player.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The Player object is controlled by the user by touching and dragging. It can fire bullets and perform other specialized attacks against enemies. If the Player's life depleats to 0, it's game over!

import SpriteKit

class Player: GameObject, ArmedWithProjectiles {
  
  // How often the player fires a bullet (in seconds) when firing.
  private let fireBulletIntervalSeconds: Double
  
  // The bullet fire timer. If active, this will trigger bullet fires every fireBulletIntervalSeconds time interval.
  var fireBulletTimer: Timer?
  
  override init(position: CGPoint, gameState: GameState) {
    self.fireBulletIntervalSeconds = 0.1
    super.init(position: position, gameState: gameState)
    self.nodeName = "player"
    
    subscribeToUserInteractionStateChanges()
  }
  
  // TODO: temporary color and shape.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let size = 0.15 * scale
    let node = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    node.position = self.position
    node.fillColor = SKColor.blue
    self.gameSceneNode = node
    return node
  }
  
  //------------------------------------------------------------------------------
  // Methods for the ArmedWithProjectiles protocol.
  //------------------------------------------------------------------------------
  
  // Start firing bullets at the firing rate (fireBulletIntervalSeconds). This will continue to fire bullets at each of the intervals until stopFireBulletTimer() is called.
  func startFireBulletTimer() {
    self.fireBulletTimer = startLoopedTimer(every: self.fireBulletIntervalSeconds, callbackFunctionSelector: #selector(self.fireBullet), fireImmediately: true)
  }
  
  // Stops firing bullets by invalidating the fireBulletTimer.
  func stopFireBulletTimer() {
    self.fireBulletTimer?.invalidate()
  }
  
  // Called by the fireBulletTimer at each fire interval to shoot a bullet.
  @objc func fireBullet() {
    let playerPosition = self.getSceneNode().position
    let bullet = Bullet(position: CGPoint(x: playerPosition.x, y: playerPosition.y), gameState: self.gameState, speed: 2.0)
    bullet.setColor(to: GameConfiguration.friendlyColor)
    bullet.setMovementDirection(to: CGVector(dx: 0.0, dy: 1.0))
    bullet.addCollisionTestCategory(PhysicsCollisionBitMask.enemy)
    bullet.addCollisionTestCategory(PhysicsCollisionBitMask.environment)
    self.gameState.inform(.spawnPlayerBullet, value: bullet)
  }
  
  //------------------------------------------------------------------------------
  // Methods for overriding the GameObject's touch handlers to trigger bullet firing.
  //------------------------------------------------------------------------------
  
  // Moves the player towards the user's touch position if the player is currently touched down.
  override func touchMoved(to: CGPoint) {
    let playerPosition = self.getSceneNode().position
    let dx = to.x - playerPosition.x
    let dy = to.y - playerPosition.y
    move(by: CGVector(dx: dx, dy: dy))
    self.gameState.set(.playerPosition, to: self.position)
  }
  
  // If this node is touched, start the bullet fire timer.
  override func touchDown(at: CGPoint) {
    if let gameSceneNode = self.gameSceneNode as? SKShapeNode {
      gameSceneNode.fillColor = SKColor.red
    }
    startFireBulletTimer()
  }
  
  // If this node is touched up, stop the bullet timer.
  override func touchUp(at: CGPoint) {
    if let gameSceneNode = self.gameSceneNode as? SKShapeNode {
      gameSceneNode.fillColor = SKColor.blue
    }
    stopFireBulletTimer()
  }
  
}
