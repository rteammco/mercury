//
//  SetGameScene.swift
//  Mercury
//
//  Created by Richard Teammco on 4/5/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  This action handles switching between GameScenes. When executed, it will swap the active GameScene to another scene.

class SetGameScene: EventAction {
  
  let gameSceneName: String
  
  // TODO: The gameSceneName should be an enum instead.
  // TODO: There should be a GameScene "library" or factory where scenes can be selected, swapped, and saved. A saved GameScene should have its state preserved while another active scene takes over. This will allow for more dynamic level/scene management.
  init(to gameSceneName: String) {
    self.gameSceneName = gameSceneName
  }
  
  override func execute(withOptionalValue optionalValue: Any? = nil) {
    if let gameScene = self.caller {
      switch self.gameSceneName {
      case "main menu":
        gameScene.setCurrentLevel(to: MainMenu())
      default:
        print("Unknown game scene:", self.gameSceneName)
      }
    }
  }
  
}
