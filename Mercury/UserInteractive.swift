//
//  InteractiveObject.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The UserInteractive protocol allows a GameObject to be interactable by the user.

protocol UserInteractive {
  
  // Set to true if the object is currently being touched.
  var isTouched: Bool { set get }
  
  // Called when the user touches the object.
  func touchDown()
  
  // Called when the user stops touch action after touching down on the object.
  func touchUp()
  
}
