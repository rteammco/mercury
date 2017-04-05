//
//  GameStateListener.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  Defines a protocol for any objects that wish to subscribe to a GameState variable.

protocol GameStateListener {
  
  // When the GameState changes, any subscriptions will be informed through this method.
  func reportStateChange(key: GameStateKey, value: Any)
  
}
