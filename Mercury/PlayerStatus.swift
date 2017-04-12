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
  
  private var playerLevel: Int
  
  // Player experience and level variables.
  private let basePlayerExperienceRequirement: Int
  private let playerExperienceRequirementGrowthRate: CGFloat
  private var currentPlayerExperience: Int
  
  // TODO: This should probably have access to the GameState for alerting things like leveling up the player, etc.
  init() {
    // TODO: These should be set from a database and configuration file(s).
    self.playerLevel = 1
    
    self.basePlayerExperienceRequirement = 100
    self.playerExperienceRequirementGrowthRate = 1.5
    self.currentPlayerExperience = 0
  }
  
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
    }
  }
  
}
