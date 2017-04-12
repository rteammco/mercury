//
//  DisplayTextAction.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A simple event that makes text appear on the screen. The text then fades out after a few seconds.

import Foundation

class DisplayText: EventAction {
  
  private let message: String
  private let duration: TimeInterval
  private let fadeOutTime: TimeInterval
  
  init(_ message: String, forDuration duration: TimeInterval = 1, withFadeOutDuration fadeOutTime: TimeInterval = 1) {
    self.message = message
    self.duration = duration
    self.fadeOutTime = fadeOutTime
  }
  
  override func execute() {
    if let gameScene = self.caller {
      gameScene.displayTextOnScreen(message: self.message, forDuration: self.duration, withFadeOutDuration: self.fadeOutTime)
    }
  }
}
