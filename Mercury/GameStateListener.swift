//
//  GameStateListener.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  Defines a protocol for any objects that wish to subscribe to a GameState variable.

protocol GameStateListener {
  func reportStateChange(key: String, value: Any)
}
