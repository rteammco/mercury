//
//  LootPackage.swift
//  Mercury
//
//  Created by Richard Teammco on 4/14/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  This class provides an easy way for levels to set up various loot that the player is awarded. It handles automatic randomization and loot tables where applicable.

import SpriteKit

// The loot struct contains rewards that will be returned when LootPackage.generateLoot() is called.
struct Loot {
  var experience: Int = 0
  var health: CGFloat = 0.0
}

// The LootPackage class handles generating a loot struct given some parameters.
class LootPackage {
  
  private var experienceAmount: Int
  
  private var healthAmountLowerBound: CGFloat
  private var healthAmountUpperBound: CGFloat
  private var healthDropRate: CGFloat
  
  init() {
    self.experienceAmount = 0
    self.healthAmountLowerBound = 0.0
    self.healthAmountUpperBound = 0.0
    self.healthDropRate = 0.0
  }
  
  // Generates a Loot struct based on the given loot parameters and probabilities.
  func generateLoot() -> Loot {
    var loot = Loot()
    loot.experience = self.experienceAmount
    if self.healthDropRate >= Util.getUniformRandomValue() {
      loot.health = round(Util.getUniformRandomValue(between: self.healthAmountLowerBound, and: self.healthAmountUpperBound))
    }
    return loot
  }
  
  // Set the amount of experience rewarded by this loot.
  func setExperieceReward(to experienceAmount: Int) {
    self.experienceAmount = experienceAmount
  }
  
  // Set the amount of health rewarded by this loot. Optionally, set a dropRate between 0 and 1 that will dictate the probability that this loot is generated.
  func setHealthReward(to healthAmount: CGFloat, withDropRate dropRate: CGFloat = 1.0) {
    setHealthReward(between: healthAmount, and: healthAmount, withDropRate: dropRate)
  }
  
  // Same as the setHealthReward above, but the amount of health rewarded is randomized between the given upper and lower bounds.
  func setHealthReward(between healthAmountLowerBound: CGFloat, and healthAmountUpperBound: CGFloat, withDropRate dropRate: CGFloat = 1.0) {
    self.healthAmountLowerBound = healthAmountLowerBound
    self.healthAmountUpperBound = healthAmountUpperBound
    self.healthDropRate = dropRate
    // Normalize health drop rate.
    if self.healthDropRate < 0.0 {
      self.healthDropRate = 0.0
    } else if self.healthDropRate > 1.0 {
      self.healthDropRate = 1.0
    }
  }
  
}
