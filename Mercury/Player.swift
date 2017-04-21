//
//  Player.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The Player object is controlled by the user by touching and dragging. It can fire bullets and perform other specialized attacks against enemies. If the Player's life depleats to 0, it's game over!

import SpriteKit

class Player: PhysicsEnabledGameObject, ArmedWithProjectiles {
  
  // The player fire timer key. If active, this will trigger bullet fires every fireBulletIntervalSeconds time interval.
  static let fireBulletTimerKey = "player bullet timer"
  
  // Bullet damage.
  var bulletDamage: CGFloat = 0
  
  override init(position: CGPoint) {
    super.init(position: position)
    GameScene.gameState.set(.playerPosition, to: getPosition())
    self.nodeName = "player"
    
    updatePlayerVariables()
    
    // Customize physics properties:
    self.physicsIsDynamic = false
    self.physicsMass = 1.0
    self.physicsRestitution = 0.5
    self.physicsFriction = 0.5
    self.physicsAllowsRotation = false
    setCollisionCategory(PhysicsCollisionBitMask.friendly)
    addCollisionTestCategory(PhysicsCollisionBitMask.enemy)
    
    subscribeToUserInteractionStateChanges()
    GameScene.gameState.subscribe(self, to: .playerLeveledUp)
    GameScene.gameState.subscribe(self, to: .playerHealthChange)
  }
  
  // Updates the player's variables based on the current player status, which scales with the player's level. This updates the player's bullet damage, and sets the player's health to the maximum current health value.
  private func updatePlayerVariables() {
    let playerStatus = GameScene.gameState.getPlayerStatus()
    self.bulletDamage = playerStatus.getBasePlayerDamage()
    initializeHitPoints(playerStatus.getMaxPlayerHealth())
  }
  
  // TODO: temporary color and shape.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let size = 0.15 * scale
    let node = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    node.position = getPosition()
    node.fillColor = SKColor.blue
    self.gameSceneNode = node
    self.initializePhysics()
    return node
  }
  
  override func reportStateChange(key: GameStateKey, value: Any) {
    super.reportStateChange(key: key, value: value)
    if key == .playerLeveledUp {
      updatePlayerVariables()
      GameScene.gameState.set(.playerHealth, to: getHitPoints())
    } else if key == .playerHealthChange {
      if let amount = value as? CGFloat {
        changeHitPoints(by: amount)
      }
    }
  }
  
  //------------------------------------------------------------------------------
  // Methods handling game events.
  //------------------------------------------------------------------------------
  
  override func changeHitPoints(by amount: CGFloat) {
    super.changeHitPoints(by: amount)
    GameScene.gameState.set(.playerHealth, to: getHitPoints())
  }
  
  override func destroyObject() {
    super.destroyObject()
    GameScene.gameState.inform(.playerDied, value: self)
  }
  
  //------------------------------------------------------------------------------
  // Methods for the ArmedWithProjectiles protocol.
  //------------------------------------------------------------------------------
  
  // Start firing bullets at the firing rate (fireBulletIntervalSeconds). This will continue to fire bullets at each of the intervals until stopFireBulletTimer() is called.
  func startFireBulletTimer() {
    let bulletFireIntervalSeconds = GameScene.gameState.getTimeInterval(forKey: .playerBulletFireInterval)
    startLoopedTimer(withKey: Player.fireBulletTimerKey, every: bulletFireIntervalSeconds, withCallback: fireBullet, fireImmediately: true)
  }
  
  // Stops firing bullets by invalidating the fireBulletTimer.
  func stopFireBulletTimer() {
    stopLoopedTimer(withKey: Player.fireBulletTimerKey)
  }
  
  // Called by the fireBulletTimer at each fire interval to shoot a bullet.
  func fireBullet() {
    let playerPosition = Util.getPlayerWorldPosition()
    let bullet = Bullet(position: CGPoint(x: playerPosition.x, y: playerPosition.y), speed: 2.0, damage: self.bulletDamage)
    bullet.setColor(to: GameConfiguration.friendlyColor)
    bullet.setMovementDirection(to: CGVector(dx: 0.0, dy: 1.0))
    bullet.addCollisionTestCategory(PhysicsCollisionBitMask.enemy)
    bullet.addCollisionTestCategory(PhysicsCollisionBitMask.environment)
    GameScene.gameState.inform(.spawnPlayerBullet, value: bullet)
  }
  
  //------------------------------------------------------------------------------
  // Methods for overriding the GameObject's touch handlers to trigger bullet firing.
  //------------------------------------------------------------------------------
  
  // Moves the player towards the user's touch position if the player is currently touched down.
  override func touchMoved(to: CGPoint) {
    let playerPosition = getPosition()
    let dx = to.x - playerPosition.x
    let dy = to.y - playerPosition.y
    move(by: CGVector(dx: dx, dy: dy))
    GameScene.gameState.set(.playerPosition, to: getPosition())
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
