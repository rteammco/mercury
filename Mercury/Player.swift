//
//  Player.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The Player object is controlled by the user by touching and dragging. It can fire bullets and perform other specialized attacks against enemies. If the Player's life depleats to 0, it's game over!

import SpriteKit

class Player: UserInteractiveGameObject {
  
  // How often the player fires a bullet (in seconds) when firing.
  private let fireBulletIntervalSeconds: Double
  
  // The bullet fire timer. If active, this will trigger bullet fires every fireBulletIntervalSeconds time interval.
  private var fireBulletTimer: Timer?
  
  override init(position: CGPoint) {
    self.fireBulletIntervalSeconds = 0.1
    super.init(position: position)
    self.nodeName = "player"
  }
  
  // TODO: temporary color and shape.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let size = 0.15 * scale
    let node = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    node.position = self.position
    print(node.position)
    node.fillColor = SKColor.blue
    self.gameSceneNode = node
    return node
  }
  
  // Moves the player towards the user's touch position if the player is currently touched down.
  func movePlayerIfTouched(towards: CGPoint, elapsedTime: TimeInterval) {
    if self.isTouched {
      let playerPosition = self.getSceneNode().position
      let dx = towards.x - playerPosition.x
      let dy = towards.y - playerPosition.y
      self.moveUpdate(dx: dx, dy: dy, elapsedTime: elapsedTime)
    }
  }
  
  // Start firing bullets at the firing rate (fireBulletIntervalSeconds). This will continue to fire bullets at each of the intervals until stopFireBulletTimer() is called.
  // TODO: we may want to move this method into the GameObject super class.
  private func startFireBulletTimer() {
    let fireBulletTimer = Timer.scheduledTimer(timeInterval: self.fireBulletIntervalSeconds, target: self, selector: #selector(self.fireBullet), userInfo: nil, repeats: true)
    self.fireBulletTimer = fireBulletTimer
    fireBullet()  // Also fire at time 0 before the timer ticks.
  }
  
  // Stops firing bullets by invalidating the fireBulletTimer.
  // TODO: we may want to move this method into the GameObject super class.
  private func stopFireBulletTimer() {
    if let fireBulletTimer = self.fireBulletTimer {
      fireBulletTimer.invalidate()
    }
  }
  
  // Called by the fireBulletTimer at each fire interval to shoot a bullet.
  // TODO: we may want to move this method into the GameObject super class.
  @objc func fireBullet() {
    let playerPosition = self.getSceneNode().position
    let bullet = Bullet(position: CGPoint(x: playerPosition.x, y: playerPosition.y), speed: 2.0)
    //self.level.addFriendlyProjectile(projectile: bullet)
  }
  
  override func touchDown() {
    super.touchDown()
    if let gameSceneNode = self.gameSceneNode as? SKShapeNode {
      gameSceneNode.fillColor = SKColor.red
    }
    startFireBulletTimer()
  }
  
  override func touchUp() {
    super.touchUp()
    if let gameSceneNode = self.gameSceneNode as? SKShapeNode {
      gameSceneNode.fillColor = SKColor.blue
    }
    stopFireBulletTimer()
  }
  
}
