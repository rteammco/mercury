//
//  DisplayTextAction.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A simple event that makes text appear on the screen. The text then fades out after a few seconds.

import Foundation

class DisplayTextAction: EventAction {
  
  let message: NSString
  
  init(message: NSString) {
    self.message = message
  }
  
  override func execute() {
    if let gameScene = self.caller as? GameScene {
      gameScene.displayTextOnScreen(message: self.message)
    }
  }
}
