//
//  CreateExperienceTokens.swift
//  Mercury
//
//  Created by Richard Teammco on 4/12/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  Creates an experience token at the location of the dead enemy.

import SpriteKit

class CreateExperienceTokens: EventAction {
  
  let tokenValue: CGFloat
  
  init(withValue tokenValue: CGFloat) {
    self.tokenValue = tokenValue
  }
  
  override func execute(withOptionalValue optionalValue: Any? = nil) {
    //if let gameScene = self.caller {
      //let gameState = gameScene.getGameState()
      
      print("Creating XP tokens")
      if let _ = optionalValue as? Enemy {
        print("Got enemy as optional value")
      }
    //}
  }
  
}
