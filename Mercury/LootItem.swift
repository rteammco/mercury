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
  
  // A utility enum for other objects to organize loot items by type.
  enum ItemType {
    case experienceOrb
    case healthOrb
  }
  
  // Tracks the last updated distance of this item from the Player.
  var lastDistanceToPlayer: CGFloat
  
  override init(position: CGPoint, gameState: GameState) {
    let playerPosition = Util.getPlayerWorldPosition(fromGameState: gameState)
    self.lastDistanceToPlayer = Util.getDistance(between: position, and: playerPosition)
    super.init(position: position, gameState: gameState)
  }
  
  // Creates a loot orb object with the given properties. Certain items that take the appearance of a loot orb should use this method to build it.
  // This method handles initializing phyiscs and setting the scene node. To apply, use the following createGameSceneNode code in the orb object (as an example):
  // override func createGameSceneNode(scale: CGFloat) -> SKNode {
  //   return createLootOrb(ofRadius: scale * 0.05, withColor: SKColor.red, withAnimationFile: "LootOrbHealth.sks")
  // }
  func createLootOrb(ofRadius radius: CGFloat, withColor color: SKColor, withAnimationFile animationFile: String) -> SKNode {
    let node = SKShapeNode(circleOfRadius: radius)
    node.position = getPosition()
    node.fillColor = color
    if let emitter = SKEmitterNode(fileNamed: animationFile) {
      node.addChild(emitter)
    }
    self.gameSceneNode = node
    initializePhysics()
    return node
  }
  
  // This update forces this item to never increase its distance from the player. This prevents items moving towards the player using a gravitational force from "overshooting" and moving out of orbit.
  //
  // TODO: This is a current "hacky" solution using the SKFieldNode.
  func restrictItemDistanceFromPlayer() {
    let lootPosition = getPosition()
    let playerPosition = Util.getPlayerWorldPosition(fromGameState: self.gameState)
    let distanceToPlayer = Util.getDistance(between: lootPosition, and: playerPosition)
    
    if distanceToPlayer > self.lastDistanceToPlayer {
      let moveDistance = distanceToPlayer - self.lastDistanceToPlayer
      let directionToMove = Util.getDirectionVector(from: lootPosition, to: playerPosition)
      let adjustmentVector = Util.scaleVector(directionToMove, by: moveDistance)
      move(by: adjustmentVector)
    } else {
      self.lastDistanceToPlayer = distanceToPlayer
    }
  }
  
  // Applies the reward that's being carried by this loot item to the Player. This typically happens after the loot item collides with the Player when they "pick it up".
  func applyReward() {
    // Override as needed.
  }
  
}
