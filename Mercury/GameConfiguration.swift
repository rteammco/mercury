//
//  GameConfiguration.swift
//  Mercury
//
//  Created by Richard Teammco on 3/26/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A list of global game configuration values that can be adjusted. These are stylistic configurations, such as fonts, colors, etc. used throughout the game.

import SpriteKit

struct GameConfiguration {
  
  //------------------------------------------------------------------------------
  // Fonts.
  //------------------------------------------------------------------------------
  
  static let mainFont: String = "AppleSDGothicNeo-Light"
  static let mainFontSize: CGFloat = 60
  
  static let secondaryFont: String = "AppleSDGothicNeo-UltraLight"
  static let secondaryFontSize: CGFloat = 40
  
  //------------------------------------------------------------------------------
  // General colors.
  //------------------------------------------------------------------------------
  
  static let primaryColor: SKColor = SKColor.yellow
  static let secondaryColor: SKColor = SKColor.cyan
  static let friendlyColor: SKColor = SKColor.green
  static let enemyColor: SKColor = SKColor.red
  
  //------------------------------------------------------------------------------
  // HUD design and colors.
  //------------------------------------------------------------------------------
  
  static let hudHealthBarColor: SKColor = SKColor.red
  static let hudExperienceBarColor: SKColor = SKColor.yellow
  static let hudBarAlpha: CGFloat = 0.75
  
  static let hudHealthTextColor: SKColor = SKColor.white
  static let hudHealthTextFont: String = "PingFangTC-Regular"
  static let hudHealthTextFontSize: CGFloat = 28
  
  static let hudPlayerLevelTextColor: SKColor = SKColor.white
  static let hudPlayerLevelTextFont: String = "PingFangTC-SemiBold"
  static let hudPlayerLevelTextFontSize: CGFloat = 30
  
}
