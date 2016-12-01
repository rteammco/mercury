//
//  Level.swift
//  Mercury
//
//  Created by Richard Teammco on 11/16/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  Defines a generic level, which provides some basic common functionality. A level should be extended with specific level instances.

import SpriteKit

class Level {
  
  // A reference to the GameScene that's in charge of all the sprites and user interactions.
  private var gameScene: GameScene
  
  // The player game object.
  private var player: Player?
  
  // Enemies that are currently engaging with the player.
  private var enemies: [Enemy]
  
  // Projectiles (e.g. bullets) fired by the player or units friendly to the player.
  private var frieldlyProjectiles: [GameObject]
  
  // A line that fades out over time. Used for visualization of the user's touch input.
  private var linePathNode: SKShapeNode?
  
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    self.enemies = [Enemy]()
    self.frieldlyProjectiles = [GameObject]()
    createPlayer()
    createLinePathNode()
  }
  
  // Add the player centered at the bottom of the screen.
  private func createPlayer() {
    let screenSize = self.gameScene.size
    // TODO: make size an easily adjustable constant equation somewhere.
    let size = (screenSize.width + screenSize.height) * 0.05
    let xPos = 0
    let yPos = Int(-screenSize.height / 2 + size)
    let player = Player(level: self)
    self.player = player
    self.gameScene.addGameObject(gameObject: player, position: CGPoint(x: xPos, y: yPos), scaleSpeed: false)
  }
  
  // Creates a line that fades over time for visualization of the user's touch input.
  private func createLinePathNode() {
    let linePathNode = SKShapeNode.init()
    linePathNode.lineWidth = 5.0
    linePathNode.strokeColor = SKColor.green
    linePathNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),
                                        SKAction.removeFromParent()]))
    self.linePathNode = linePathNode
  }
  
  // Adds an enemy to the scene.
  func addEnemy(enemy: Enemy, position: CGPoint) {
    self.gameScene.addGameObject(gameObject: enemy, position: position)
    self.enemies.append(enemy)
  }
  
  // Adds a friendly projectile (projected by the player or units friendly to the player) into the GameScene.
  func addFriendlyProjectile(projectile: GameObject, position: CGPoint) {
    self.gameScene.addGameObject(gameObject: projectile, position: position)
    self.frieldlyProjectiles.append(projectile)
  }
  
  // Called by the GameScene when the user starts touching the device screen.
  func touchDown(atPoint position: CGPoint) {
    // TODO: is there a better way to get the exact node that was touched?
    let touchedNodes = self.gameScene.nodes(at: position)
    for node in touchedNodes {
      if node.name == self.player?.nodeName {
        self.player?.touchDown()
      }
    }
    self.addEnemy(enemy: Enemy(speed: 0.25), position: CGPoint(x: 0, y: 700))  // TODO: remove!
  }
  
  // Called by the GameScene when the user moves their finger while touching down on the screen.
  func touchMoved(toPoint position: CGPoint) {
    if let linePathNode = self.linePathNode?.copy() as! SKShapeNode? {
      let path = CGMutablePath.init()
      path.move(to: self.gameScene.getPreviousTouchPosition())
      path.addLine(to: position)
      linePathNode.path = path
      self.gameScene.addChild(linePathNode)
    }
  }
  
  // Called by the GameScene when the user stops touching the device screen.
  func touchUp(atPoint position: CGPoint) {
    if let player = self.player {
      if player.isTouched {
        player.touchUp()
      }
    }
  }
  
  // Updates all of the GameObjects as needed, given the elapsed time (in seconds) since the previous frame.
  // This calls update on all components of the level that need to be updated. This method also finds which objects need to be removed from the scene and handles collision detections.
  func update(_ elapsedTime: TimeInterval) {
    // Update the player.
    let previousTouchPosition = self.gameScene.getPreviousTouchPosition()
    self.player?.movePlayerIfTouched(towards: previousTouchPosition, elapsedTime: elapsedTime)
    
    // Update all enemies.
    for enemy in self.enemies {
      enemy.update(elapsedTime)
    }
    
    // Update all projectiles, and only keep those that are still valid (i.e. still within screen bounds and did not collide).
    var validFriendlyProjectiles = [GameObject]()
    for projectile in self.frieldlyProjectiles {
      projectile.update(elapsedTime)
      if projectile.isAlive {
        validFriendlyProjectiles.append(projectile)
      } else {
        projectile.removeSceneNodeFromGameScene()
      }
    }
    self.frieldlyProjectiles = validFriendlyProjectiles
  }
  
}
