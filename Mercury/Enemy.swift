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
  
  init(position: CGPoint, gameState: GameState, speed: CGFloat) {
    super.init(position: position, gameState: gameState)
    self.nodeName = "enemy"
    self.scaleMovementSpeed(speed)
    self.setMovementDirection(to: CGVector(dx: 0, dy: -1))  // Top to bottom of screen.
    initializeHitPoints(self.gameState.getCGFloat(forKey: .enemyHealthBase))
    
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
    node.position = getPosition()
    node.fillColor = SKColor.cyan
    self.gameSceneNode = node
    self.initializePhysics()
    return node
  }
  
  // When an enemy dies, inform the global GameState of the specific event.
  override func destroyObject() {
    super.destroyObject()
    ParticleSystems.runExplosionEffect(on: self)
    self.gameState.inform(.enemyDied, value: self)
  }
  
  //------------------------------------------------------------------------------
  // Methods for scripting movement.
  //------------------------------------------------------------------------------
  
  // Creates a movement path for the enemy to follow. This once this is called, the enemy will follow this path instead of just going straight the whole time.
  func startMovement() {
    // TODO: fix, randomize, and use appropriate scaling variables.
    let path = UIBezierPath()
    let currentPosition = self.getPosition()
    path.move(to: currentPosition)
    
    path.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: currentPosition.x, y: 200), controlPoint2: CGPoint(x: 100, y: 50))
    //path.addLine(to: CGPoint(x: 0, y: 0))
    
    path.addLine(to: CGPoint(x: 300, y: 300))
    path.addLine(to: CGPoint(x: 0, y: 300))
    path.close()
    
//    let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 300, startAngle: 0, endAngle: CGFloat.pi * 4, clockwise: true)
    
    let movement = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, duration: 5)
    self.gameSceneNode?.run(movement)
    // TODO: repeat.
  }
  
  //------------------------------------------------------------------------------
  // Methods for the ArmedWithProjectiles protocol.
  //------------------------------------------------------------------------------
  
  // Start firing bullets at the firing rate (fireBulletIntervalSeconds). This will continue to fire bullets at each of the intervals until stopFireBulletTimer() is called.
  // TODO: we may want to move this method into the GameObject super class.
  func startFireBulletTimer() {
    let bulletFireIntervalSeconds = self.gameState.getTimeInterval(forKey: .enemyBulletFireInterval)
    self.fireBulletTimer = startLoopedTimer(every: bulletFireIntervalSeconds, callbackFunctionSelector: #selector(self.fireBullet))
  }
  
  // Stops firing bullets by invalidating the fireBulletTimer.
  // TODO: we may want to move this method into the GameObject super class.
  func stopFireBulletTimer() {
    self.fireBulletTimer?.invalidate()
  }
  
  // Called by the fireBulletTimer at each fire interval to shoot a bullet.
  @objc func fireBullet() {
    let enemyPosition = getPosition()
    let bullet = Bullet(position: CGPoint(x: enemyPosition.x, y: enemyPosition.y), gameState: self.gameState, speed: 1.0, damage: self.gameState.getCGFloat(forKey: .enemyBulletDamage))
    bullet.setColor(to: GameConfiguration.enemyColor)
    bullet.addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    bullet.addCollisionTestCategory(PhysicsCollisionBitMask.environment)
    
    // Set the direction of the bullet based on the player's current position.
    let playerPosition = self.gameState.getPoint(forKey: .playerPosition)
    var bulletDirection = Util.getDirectionVector(from: enemyPosition, to: playerPosition)
    bulletDirection.dx += Util.getUniformRandomValue(between: -0.1, and: 0.1)
    bulletDirection.dy += Util.getUniformRandomValue(between: -0.1, and: 0.1)
    bullet.setMovementDirection(to: bulletDirection)
    
    self.gameState.inform(.spawnEnemyBullet, value: bullet)
  }
  
}
