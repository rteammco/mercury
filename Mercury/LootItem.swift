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
  
  // The type of item defines the appearance and behavior of this object.
  enum ItemType {
    case HealthOrb, ExperienceOrb
  }
  private let itemType: ItemType
  
  // Loot orb values.
  private var experiencePoints: CGFloat?
  private var healthPoints: CGFloat?
  private var lastDistanceToPlayer: CGFloat?
  
  // Use this constructor if this is an experience orb and awards experience points.
  init(position: CGPoint, gameState: GameState, withExperience experiencePoints: CGFloat) {
    self.itemType = .ExperienceOrb
    self.experiencePoints = experiencePoints
    let playerPosition = gameState.getPoint(forKey: .playerPosition)
    self.lastDistanceToPlayer = Util.getDistance(between: position, and: playerPosition)
    
    super.init(position: position, gameState: gameState)
    self.nodeName = "experience orb"
    
    setCollisionCategory(PhysicsCollisionBitMask.item)
    addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    addFieldAttractionBitMask(PhysicsCollisionBitMask.playerGlobalLootGravityField)
  }
  
  // Use this constructor if this is a health orb and awards player health.
  init(position: CGPoint, gameState: GameState, withHealth healthPoints: CGFloat) {
    self.itemType = .HealthOrb
    self.healthPoints = healthPoints
    let playerPosition = gameState.getPoint(forKey: .playerPosition)
    self.lastDistanceToPlayer = Util.getDistance(between: position, and: playerPosition)
    
    super.init(position: position, gameState: gameState)
    self.nodeName = "health orb"
    
    setCollisionCategory(PhysicsCollisionBitMask.item)
    addCollisionTestCategory(PhysicsCollisionBitMask.friendly)
    addFieldAttractionBitMask(PhysicsCollisionBitMask.playerGlobalLootGravityField)
  }
  
  // Returns a "loot orb" appearance node, which glows in particles and flies over to the player. This can be either a health orb or experience orb.
  private func createOrbNode(scale: CGFloat) -> SKNode {
    let radius = 0.005 * scale
    let node = SKShapeNode(circleOfRadius: radius)
    node.position = getPosition()
    if self.itemType == .ExperienceOrb {
      node.fillColor = GameConfiguration.hudExperienceBarColor
      if let emitter = SKEmitterNode(fileNamed: "LootOrbExperience.sks") {
        node.addChild(emitter)
      }
    } else if itemType == .HealthOrb {
      node.fillColor = GameConfiguration.hudHealthBarColor
      if let emitter = SKEmitterNode(fileNamed: "LootOrbHealth.sks") {
        node.addChild(emitter)
      }
    }
    return node
  }
  
  // Creates the LootItem node depending on the type of loot item this is.
  override func createGameSceneNode(scale: CGFloat) -> SKNode {
    var node: SKNode?
    if self.itemType == .HealthOrb || self.itemType == .ExperienceOrb {
      node = createOrbNode(scale: scale)
    } else {
      node = SKShapeNode()  // empty node
    }
    self.gameSceneNode = node
    initializePhysics()
    return node!
  }
  
  // Applies the reward that's being carried by this loot item to the Player. This typically happens after the loot item collides with the Player when they "pick it up".
  func applyReward() {
    if self.itemType == .ExperienceOrb, let experiencePoints = self.experiencePoints {
      if let playerStatus = self.gameState.get(valueForKey: .playerStatus) as? PlayerStatus {
        playerStatus.addPlayerExperience(Int(experiencePoints))
        self.gameState.inform(.playerExperienceChange)
      }
    } else if self.itemType == .HealthOrb, let healthPoints = self.healthPoints {
      self.gameState.inform(.playerHealthChange, value: healthPoints)
    }
  }
  
  // This update forces this item to never increase its distance from the player. This prevents items moving towards the player using a gravitational force from "overshooting" and moving out of orbit.
  //
  // TODO: This is a current "hacky" solution using the SKFieldNode.
  override func update(elapsedTime timeSinceLastUpdate: TimeInterval) {
    // This only applies to the orbs that fly over to the Player.
    if self.itemType != .ExperienceOrb && self.itemType != .HealthOrb {
      return
    }
    
    let lootPosition = getPosition()
    let playerPosition = gameState.getPoint(forKey: .playerPosition)
    let distanceToPlayer = Util.getDistance(between: lootPosition, and: playerPosition)
    
    guard let lastDistanceToPlayer = self.lastDistanceToPlayer else {
      self.lastDistanceToPlayer = distanceToPlayer
      return
    }
    
    if distanceToPlayer > lastDistanceToPlayer {
      let moveDistance = distanceToPlayer - lastDistanceToPlayer
      let directionToMove = Util.getDirectionVector(from: lootPosition, to: playerPosition)
      let adjustmentVector = Util.scaleVector(directionToMove, by: moveDistance)
      move(by: adjustmentVector)
    } else {
      self.lastDistanceToPlayer = distanceToPlayer
    }
  }
  
}
