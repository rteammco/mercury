//
//  GameState.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The GameState object acts as an in-memory database that can track all variables about the game's state. Objects such as the GameScene or GameObjects can utilize this to keep all game state variables (such as player health, number of enemies, score, and literally any other information) in one global place. This can be useful for quickly saving and restoring the game state. It's primary purpose, however, is to allow Events and other GameStateListener objects to subscribe themselves as listeners to specific variables. Whenever these variables are updated, all listeners subscribed to that variable will be notified of the change.

import SpriteKit

class GameState {
  
  // Maps GameState variables (identified by a String key) to whatever value they are given.
  var gameStateValues: [GameStateKey: Any]
  
  // Maps variables (identified by their key) to a set of GameStateListeners which have subscribed to getting reports on changes for those variables.
  var gameStateListeners: [GameStateKey: [GameStateListener]]
  
  init() {
    self.gameStateValues = [GameStateKey: Any]()
    self.gameStateListeners = [GameStateKey: [GameStateListener]]()
  }
  
  // Set a value for the GameState. If the value did not exist before, it will be modified. Keys are case-sensitive and must match exactly.
  // Example: gameState.set("player health", to: 100)
  func set(_ key: GameStateKey, to value: Any) {
    self.gameStateValues[key] = value
    inform(key, value: value)
  }
  
  // The following methods are the same as above, but are intended to set numerical values as a specific type to avoid ambiguity.
  func setInt(_ key: GameStateKey, to value: Int) {
    set(key, to: value)
  }
  func setCGFloat(_ key: GameStateKey, to value: CGFloat) {
    set(key, to: value)
  }
  func setTimeInterval(_ key: GameStateKey, to value: TimeInterval) {
    set(key, to: value)
  }
  
  // This informs all GameStateListeners subscribed to a variable of a change, but does not change the variable's value. The variable does not need to be set at all to call this method.
  // Default value is set to "true" so this method can be called just to inform of an arbitrary change in a parameter.
  // Example 1: gameState.inform("screen touched")
  // Example 2: gameState.inform("score", 25)
  func inform(_ key: GameStateKey, value: Any = true) {
    if let listeners = self.gameStateListeners[key] {
      for listener in listeners {
        listener.reportStateChange(key: key, value: value)
      }
    }
  }
  
  // Returns the GameState value set to the given key. The returned value may be nil if it was not set before. Keys are case-sensitive and must match exactly.
  //
  // Use designated "getType" functions to guarantee a valid return value for any key (see below).
  func get(valueForKey key: GameStateKey) -> Any {
    return self.gameStateValues[key] as Any
  }
  
  // Returns the GameState value for the given key interpreted as an Int. If the value has not been set or its current type is not Int, the default value will be returned.
  func getInt(forKey key: GameStateKey, defaultValue: Int = 0) -> Int {
    if let value = self.gameStateValues[key] as? Int {
      return value
    }
    return defaultValue
  }
  
  // Returns the value as a CGFloat. Default value is 0 unelss otherwise specified.
  func getCGFloat(forKey key: GameStateKey, defaultValue: CGFloat = 0.0) -> CGFloat {
    if let value = self.gameStateValues[key] as? CGFloat {
      return value
    }
    return defaultValue
  }
  
  // Returns the value as a TimeInterval. Default value is 0 unelss otherwise specified.
  func getTimeInterval(forKey key: GameStateKey, defaultValue: TimeInterval = 0.0) -> TimeInterval {
    if let value = self.gameStateValues[key] as? TimeInterval {
      return value
    }
    return defaultValue
  }
  
  // Returns the value interpreted as a 2D CGPoint. Default value is (0, 0) unless otherwise specified.
  func getPoint(forKey key: GameStateKey, defaultValue: CGPoint = CGPoint(x: 0, y: 0)) -> CGPoint {
    if let value = self.gameStateValues[key] as? CGPoint {
      return value
    }
    return defaultValue
  }
  
  // Subscribes a GameStateListener to listen to the state variable identified by the given key. Whenever this state variable is updated, the listener will be notified via the reportStateChange method.
  func subscribe(_ listener: GameStateListener, to key: GameStateKey) {
    if self.gameStateListeners[key] != nil {
      self.gameStateListeners[key]?.append(listener)
    } else {
      self.gameStateListeners[key] = [listener]
    }
  }
}
