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
  
  private var gameScene: GameScene
  
  // The size of the world (half of the average of the screen width and height).
  private var worldSize: Double
  
  // The player game object.
  private var player: Player?
  
  // A line that fades out over time. Used for visualization of the user's touch input.
  private var linePathNode: SKShapeNode?
  
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    self.worldSize = Double(self.gameScene.size.width + self.gameScene.size.height) / 4.0
    createPlayer()
    createLinePathNode()
  }
  
  // Add the player centered at the bottom of the screen.
  private func createPlayer() {
    let screenSize = self.gameScene.size
    let size = (screenSize.width + screenSize.height) * 0.05  // TODO: make this an easily adjustable constant equation somewhere
    let xPos = 0
    let yPos = Int(-screenSize.height / 2 + size)
    let player = Player(xPos: xPos, yPos: yPos, size: Int(size))
    self.player = player
    self.gameScene.addGameObject(gameObject: player)
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
  
  // Checks if player has been touched (thus toggled for movement), and then moves the player towards the given location. This is called at every frame udpate interval. The speed of movement is scaled by the player's movementSpeed variable as well as the elapsed time (shorter time intervals will yield smaller movements).
  private func movePlayerIfTouched(to position: CGPoint, elapsedTime: TimeInterval) {
    if let player = self.player {
      if player.isTouched {
        let playerPosition = player.getSceneNode().position
        var dx = position.x - playerPosition.x
        var dy = position.y - playerPosition.y
        dx = dx * CGFloat(player.movementSpeed) * CGFloat(elapsedTime)
        dy = dy * CGFloat(player.movementSpeed) * CGFloat(elapsedTime)
        player.moveBy(dx: dx, dy: dy)
      }
    }
  }
  
  func touchDown(atPoint position: CGPoint) {
    // TODO: is there a better way to get the exact node that was touched?
    let touchedNodes = self.gameScene.nodes(at: position)
    for node in touchedNodes {
      if node.name == self.player?.nodeName {
        self.player?.touchDown()
      }
    }
  }
  
  func touchMoved(toPoint position: CGPoint) {
    if let linePathNode = self.linePathNode?.copy() as! SKShapeNode? {
      let path = CGMutablePath.init()
      path.move(to: self.gameScene.getPreviousTouchPosition())
      path.addLine(to: position)
      linePathNode.path = path
      self.gameScene.addChild(linePathNode)
    }
  }
  
  func touchUp(atPoint position: CGPoint) {
    if let player = self.player {
      if player.isTouched {
        player.touchUp()
      }
    }
  }
  
  // Updates all of the GameObjects as needed, given the elapsed time (in seconds) since the previous frame.
  func update(_ elapsedTime: TimeInterval) {
    // TODO: currently only supports player.
    //player?.update(elapsedTime)
    movePlayerIfTouched(to: self.gameScene.getPreviousTouchPosition(), elapsedTime: elapsedTime)
  }
  
}