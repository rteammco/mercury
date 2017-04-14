//
//  LootItem.swift
//  Mercury
//
//  Created by Richard Teammco on 4/13/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A loot item is an object that drops from enemies or random sources and moves towards the player or waits for the player to come to it. Once it collides with the player, it will reward the player with the contents (e.g. experience, items, etc.).

import SpriteKit

class LootItem: PhysicsEnabledGameObject {
  
  let experiencePoints: Int
  var lastDistanceToPlayer: CGFloat
  
  init(position: CGPoint, gameState: GameState, withExperience experiencePoints: Int) {
    self.experiencePoints = experiencePoints
    let playerPosition = gameState.getPoint(forKey: .playerPosition)
    self.lastDistanceToPlayer = Util.getDistance(between: position, and: playerPosition)
    super.init(position: position, gameState: gameState)
    self.nodeName = "loot"
    
    setCollisionCategory(PhysicsCollisionBitMask.item)
    addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    addFieldAttractionBitMask(PhysicsCollisionBitMask.playerGravityField)
  }
  
  // TODO: temporary color and shape.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    let radius = 0.02 * scale
    let node = SKShapeNode(circleOfRadius: radius)
    node.position = getPosition()
    node.fillColor = SKColor.green
    if let emitter = SKEmitterNode(fileNamed: "Loot.sks") {
      node.addChild(emitter)
    }
    self.gameSceneNode = node
    initializePhysics()
    return node
  }
  
  // Applies the reward that's being carried by this loot item to the Player. This typically happens after the loot item collides with the Player when they "pick it up".
  func applyReward() {
    if let playerStatus = self.gameState.get(valueForKey: .playerStatus) as? PlayerStatus {
      playerStatus.addPlayerExperience(self.experiencePoints)
      self.gameState.inform(.playerExperienceChange)
    }
  }
  
  // This update forces this item to never increase its distance from the player. This prevents items moving towards the player using a gravitational force from "overshooting" and moving out of orbit.
  //
  // TODO: This is a current "hacky" solution using the SKFieldNode.
  override func update(elapsedTime timeSinceLastUpdate: TimeInterval) {
    let lootPosition = getPosition()
    let playerPosition = gameState.getPoint(forKey: .playerPosition)
    let distanceToPlayer = Util.getDistance(between: getPosition(), and: playerPosition)
    if distanceToPlayer > self.lastDistanceToPlayer {
      let moveDistance = distanceToPlayer - self.lastDistanceToPlayer
      let directionToMove = Util.getDirectionVector(from: lootPosition, to: playerPosition)
      let adjustmentVector = Util.scaleVector(directionToMove, by: moveDistance)
      move(by: adjustmentVector)
    } else {
      self.lastDistanceToPlayer = distanceToPlayer
    }
  }
  
}
