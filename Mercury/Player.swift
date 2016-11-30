//
//  Player.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The Player object is controlled by the user by touching and dragging. It can fire bullets and perform other specialized attacks against enemies. If the Player's life depleats to 0, it's game over!

import SpriteKit

class Player: InteractiveGameObject {
  
  // How often the player fires a bullet (in seconds) when firing.
  private let fireIntervalSeconds: Double
  
  // The bullet fire timer.
  private var fireBulletTimer: Timer?
  
  init(xPos: Int, yPos: Int, size: Int) {
    self.fireIntervalSeconds = 0.1
    super.init()
    
    self.nodeName = "player"
    self.movementSpeed = 4.0
    
    // TODO: temporary color and shape
    self.gameSceneNode = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.position = CGPoint(x: xPos, y: yPos)
      gameSceneNode.fillColor = SKColor.blue
    }
  }
  
  override func touchDown() {
    super.touchDown()
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.fillColor = SKColor.red
    }
    startFireBulletTimer()
  }
  
  override func touchUp() {
    super.touchUp()
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.fillColor = SKColor.blue
    }
    if let fireBulletTimer = self.fireBulletTimer {
      fireBulletTimer.invalidate()
    }
  }
  
  private func startFireBulletTimer() {
    let fireBulletTimer = Timer.scheduledTimer(timeInterval: self.fireIntervalSeconds, target: self, selector: #selector(self.fireBullet), userInfo: nil, repeats: true)
    self.fireBulletTimer = fireBulletTimer
    fireBullet()  // Also fire at time 0 before the timer ticks.
  }
  
  @objc func fireBullet() {
    print("Fired")
  }
}
