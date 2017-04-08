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
    let testLevelButton = SKLabelNode(fontNamed: GameConfiguration.mainFont)
    testLevelButton.text = "Start Test Level"
    testLevelButton.fontSize = GameConfiguration.mainFontSize
    testLevelButton.fontColor = GameConfiguration.primaryColor
    testLevelButton.position = CGPoint(x: frame.midX, y: frame.midY)
    testLevelButton.name = self.testLevelButtonName
    addChild(testLevelButton)
    
    // Subscribe to touch events to handle button presses.
    getGameState().subscribe(self, to: .screenTouchDown)
  }
  
  // Handle button touches and run the appropriate action based on the button that was pressed.
  override func reportStateChange(key: GameStateKey, value: Any) {
    if key == .screenTouchDown {
      if let screenTouchInfo = value as? ScreenTouchInfo {
        let node = screenTouchInfo.touchedNode
        if node.name == self.testLevelButtonName {
          let testLevel = TestLevel()
          setCurrentLevel(to: testLevel)
        }
      }
    }
  }
  
}
