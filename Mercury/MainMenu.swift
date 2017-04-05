//
//  MainMenu.swift
//  Mercury
//
//  Created by Richard Teammco on 4/5/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The main game menu.

import SpriteKit

class MainMenu: GameScene {
  
  private let testLevelButtonName = "test level button"
  
  override func initializeScene() {
    let width = getScaledValue(0.5)
    let height = getScaledValue(0.1)
    let testLevelButton = SKShapeNode(rectOf: CGSize(width: width, height: height))
    testLevelButton.position = CGPoint(x: frame.midX, y: frame.midY)
    testLevelButton.fillColor = SKColor.yellow
    testLevelButton.name = self.testLevelButtonName
    addChild(testLevelButton)
    
    getGameState().subscribe(self, to: .screenTouchDown)
  }
  
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

