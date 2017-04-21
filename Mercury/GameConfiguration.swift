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
  // General fonts.
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
  // Menu fonts and colors.
  //------------------------------------------------------------------------------
  
  static let menuButtonFont: String = "AppleSDGothicNeo-Light"
  static let menuButtonFontSize: CGFloat = 50
  static let menuButtonColor: SKColor = SKColor.cyan
  
  static let menuLabelFont: String = "AppleSDGothicNeo-SemiBold"
  static let menuLabelFontSize: CGFloat = 50
  static let menuLabelColor: SKColor = SKColor.yellow
  
  //------------------------------------------------------------------------------
  // HUD design and colors.
  //------------------------------------------------------------------------------
  
  static let hudHealthBarColor: SKColor = SKColor.red
  static let hudExperienceBarColor: SKColor = SKColor.yellow
  static let hudBarAlpha: CGFloat = 0.75
  static let hudBarOutlineWidth: CGFloat = 3
  
  static let hudHealthTextColor: SKColor = SKColor.white
  static let hudHealthTextFont: String = "PingFangTC-Regular"
  static let hudHealthTextFontSize: CGFloat = 28
  
  static let hudPlayerLevelTextColor: SKColor = SKColor.white
  static let hudPlayerLevelTextFont: String = "PingFangTC-SemiBold"
  static let hudPlayerLevelTextFontSize: CGFloat = 30
  
  //------------------------------------------------------------------------------
  // Object sizes/scales and positions (relative to screen height).
  //------------------------------------------------------------------------------
  
  static let hudBarWidth: CGFloat = 0.35
  static let hudBarHeight: CGFloat = 0.025
  static let hudBarYPosition: CGFloat = 0.45
  
  static let playerSize: CGFloat = 0.075
  static let defaultPlayerSpawnYPosition: CGFloat = -0.8
  
  static let bulletWidth: CGFloat = 0.02
  static let bulletHeight: CGFloat = 0.005
  
  static let miniObjectSize: CGFloat = 0.0025
  static let smallObjectSize: CGFloat = 0.05
  
  //------------------------------------------------------------------------------
  // Object speeds (scaling relative to screen height).
  //------------------------------------------------------------------------------
  
  static let enemyBulletSpeed: CGFloat = 0.5
  static let playerBulletSpeed: CGFloat = 1.0
  
  static let mediumSpeed: CGFloat = 0.75
  
}
