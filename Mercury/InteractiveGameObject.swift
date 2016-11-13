//
//  InteractiveGameObject.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  A GameObject extension that features user interaction.
//

class InteractiveGameObject: GameObject, UserInteractive {
  
  var isTouched: Bool = false
  
  func touchDown() {
    self.isTouched = true
  }
  
  func touchUp() {
    self.isTouched = false
  }
  
}
