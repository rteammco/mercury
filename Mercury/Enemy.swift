//
//  Enemy.swift
//  Mercury
//
//  Created by Richard Teammco on 12/1/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  An abstract Enemy object that should be extended to include specific enemies. This defines standard actions that most enemy units will take, such as random-interval shooting.

import SpriteKit

class Enemy: PhysicsEnabledGameObject, ArmedWithProjectiles {
  
  // The bullet fire timer. If active, this will trigger bullet fires every fireBulletIntervalSeconds time interval.
  var fireBulletTimer: Timer?
  
  // How often this enemy fires a bullet (in seconds) when firing.
  private let fireBulletIntervalSeconds: Double
  
  init(position: CGPoint, gameState: GameState, speed: CGFloat) {
    self.fireBulletIntervalSeconds = 0.5
    super.init(position: position, gameState: gameState)
    self.nodeName = "enemy"
    self.scaleMovementSpeed(speed)
    self.setMovementDirection(dx: 0, dy: -1)  // Top to bottom of screen.
    
    self.health = 200
    
    // Customize physics properties:
    self.physicsMass = 1.0
    self.physicsRestitution = 0.5
    self.physicsFriction = 0.5
    self.physicsAllowsRotation = false
    
    // Physics collision properties: Enemies can collide with the player.
    setCollisionCategory(PhysicsCollisionBitMask.enemy)
    addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    // TODO: they should probably be able to collide with the environment as well?
    
    startFireBulletTimer()
  }
  
  // TODO: temporary color and shape.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let size = 0.1 * scale
    let node = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    node.position = self.position
    node.fillColor = SKColor.cyan
    self.gameSceneNode = node
    self.initializePhysics()
    return node
  }
  
  // When an enemy dies, inform the global GameState of the specific event.
  override func destroyObject() {
    super.destroyObject()
    self.gameState.inform(.enemyDies, value: self)
  }
  
  //------------------------------------------------------------------------------
  // Methods for the ArmedWithProjectiles protocol.
  //------------------------------------------------------------------------------
  
  // Start firing bullets at the firing rate (fireBulletIntervalSeconds). This will continue to fire bullets at each of the intervals until stopFireBulletTimer() is called.
  // TODO: we may want to move this method into the GameObject super class.
  func startFireBulletTimer() {
    self.fireBulletTimer = startLoopedTimer(every: self.fireBulletIntervalSeconds, callbackFunctionSelector: #selector(self.fireBullet))
  }
  
  // Stops firing bullets by invalidating the fireBulletTimer.
  // TODO: we may want to move this method into the GameObject super class.
  func stopFireBulletTimer() {
    self.fireBulletTimer?.invalidate()
  }
  
  // Called by the fireBulletTimer at each fire interval to shoot a bullet.
  @objc func fireBullet() {
    let enemyPosition = self.getSceneNode().position
    let bullet = Bullet(position: CGPoint(x: enemyPosition.x, y: enemyPosition.y), gameState: self.gameState, speed: 1.0)
    bullet.setMovementDirection(dx: 0.0, dy: -1.0)
    bullet.addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    bullet.addCollisionTestCategory(PhysicsCollisionBitMask.environment)
    self.gameState.inform(.spawnEnemyBullet, value: bullet)
  }
  
}
