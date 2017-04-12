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
  
  static let mainFont: String = "Papyrus"
  static let mainFontSize: CGFloat = 60
  
  static let secondaryFont: String = "Papyrus"
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
  static let hudHealthBarAlpha: CGFloat = 0.75
  
  static let hudHealthTextColor: SKColor = SKColor.white
  static let hudHealthTextFont: String = "Arial-BoldMT"
  static let hudHealthTextFontSize: CGFloat = 34
  
  //------------------------------------------------------------------------------
  // UI Layers:
  // By default, everything in the game is at z-position 0. Set z-position values greater than zero to objects that should be prioritized above the game objects.
  //------------------------------------------------------------------------------
  
  static let hudZPosition: CGFloat = 1
  
}
