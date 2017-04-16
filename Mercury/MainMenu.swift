//
//  MainMenu.swift
//  Mercury
//
//  Created by Richard Teammco on 4/5/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The main game menu. Lets the user start playing a level.

import SpriteKit

class MainMenu: GameScene {
  
  private let testLevelButtonName = "test level button"
  
  // Add all buttons to the menu.
  override func initializeScene() {
    super.initializeScene()
    let testLevelButton = ButtonNode.menuButton(withText: "Start Test Level")
    testLevelButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    testLevelButton.setCallback {
      let testLevel = TestLevel()
      self.setCurrentLevel(to: testLevel)
    }
    addChild(testLevelButton)
  }
  
}

