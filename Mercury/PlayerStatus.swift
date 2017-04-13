//
//  PlayerStatus.swift
//  Mercury
//
//  Created by Richard Teammco on 4/12/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A class that contains and tracks the player's progress and status.

import SpriteKit

class PlayerStatus {
  
  private let gameState: GameState
  
  // Player level.
  private var playerLevel: Int
  
  // Player experience and level variables.
  private let basePlayerExperienceRequirement: Int
  private let playerExperienceRequirementGrowthRate: CGFloat
  private var currentPlayerExperience: Int
  
  // Player status variables.
  private let basePlayerDamage: CGFloat
  private let playerDamageScaling: CGFloat
  private let basePlayerHealth: CGFloat
  private let playerHealthScaling: CGFloat
  
  // TODO: This should probably have access to the GameState for alerting things like leveling up the player, etc.
  init(gameState: GameState) {
    self.gameState = gameState
    
    // TODO: These should be set from a database and configuration file(s).
    self.playerLevel = 1
    
    self.basePlayerExperienceRequirement = 100
    self.playerExperienceRequirementGrowthRate = 1.5
    self.currentPlayerExperience = 0
    
    self.basePlayerDamage = 10
    self.playerDamageScaling = 1.5
    self.basePlayerHealth = 100
    self.playerHealthScaling = 1.5
  }
  
  //------------------------------------------------------------------------------
  // Player level and experience.
  //------------------------------------------------------------------------------
  
  // Returns the player's current level.
  func getPlayerLevel() -> Int {
    return self.playerLevel
  }
  
  // Returns the current amount of XP the player has (only for the current level).
  func getCurrentPlayerExperience() -> Int {
    return self.currentPlayerExperience
  }
  
  // Returns the amount of experience required to level up to the next level.
  func playerExperienceRequiredToNextLevel() -> Int {
    let scaleFactor = pow(CGFloat(self.playerLevel), self.playerExperienceRequirementGrowthRate)
    return self.basePlayerExperienceRequirement * Int(scaleFactor)
  }
  
  // Adds experience to the player. If this causes the player to level up, this will also process the new player's level.
  func addPlayerExperience(_ experience: Int) {
    self.currentPlayerExperience += experience
    var nextLevelRequirement = playerExperienceRequiredToNextLevel()
    while self.currentPlayerExperience >= nextLevelRequirement {
      self.playerLevel += 1
      self.currentPlayerExperience -= nextLevelRequirement
      nextLevelRequirement = playerExperienceRequiredToNextLevel()
      self.gameState.inform(.playerLeveledUp, value: self.playerLevel)
    }
  }
  
  //------------------------------------------------------------------------------
  // Player status.
  //------------------------------------------------------------------------------
  
  // Returns the current maximum player health based on the player's current level.
  func getMaxPlayerHealth() -> CGFloat {
    return round(self.basePlayerHealth * self.playerHealthScaling * CGFloat(self.playerLevel))
  }
  
  // Returns the base damage. This value scales with level and is used to determine damage of bullets and other player weapons.
  func getBasePlayerDamage() -> CGFloat {
    return round(self.basePlayerDamage * self.playerDamageScaling * CGFloat(self.playerLevel))
  }
  
}
