//
//  GameState.swift
//  Mercury
//
//  Created by Richard Teammco on 1/31/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The GameState object acts as an in-memory database that can track all variables about the game's state. Objects such as the GameScene or GameObjects can utilize this to keep all game state variables (such as player health, number of enemies, score, and literally any other information) in one global place. This can be useful for quickly saving and restoring the game state. It's primary purpose, however, is to allow Events and other GameStateListener objects to subscribe themselves as listeners to specific variables. Whenever these variables are updated, all listeners subscribed to that variable will be notified of the change.

class GameState {
  
  // Maps GameState variables (identified by a String key) to whatever value they are given.
  var gameStateValues: [String: Any]
  
  // Maps variables (identified by their key) to a set of GameStateListeners which have subscribed to getting reports on changes for those variables.
  var gameStateListeners: [String: [GameStateListener]]
  
  init() {
    self.gameStateValues = [String: Any]()
    self.gameStateListeners = [String: [GameStateListener]]()
  }
  
  // Set a value for the GameState. If the value did not exist before, it will be modified. Keys are case-sensitive and must match exactly.
  // Example: gameState.set("player health", to: 100)
  func set(_ key: String, to value: Any) {
    self.gameStateValues[key] = value
    inform(key, value: value)
  }
  
  // This informs all GameStateListeners subscribed to a variable of a change, but does not change the variable's value. The variable does not need to be set at all to call this method.
  // Default value is set to "true" so this method can be called just to inform of an arbitrary change in a parameter.
  // Example 1: gameState.inform("screen touched")
  // Example 2: gameState.inform("score", 25)
  func inform(_ key: String, value: Any = true) {
    if let listeners = self.gameStateListeners[key] {
      for listener in listeners {
        listener.reportStateChange(key: key, value: value)
      }
    }
  }
  
  // Returns the GameState value set to the given key. The returned value may be nil if it was not set before. Keys are case-sensitive and must match exactly.
  //
  // Use designated "getType" functions to guarantee a valid return value for any key (see below).
  func get(valueForKey key: String) -> Any {
    return self.gameStateValues[key] as Any
  }
  
  // Returns the GameState value for the given key interpreted as an Int. If the value has not been set or its current type is not Int, the default value will be returned.
  func getInt(forKey key: String, defaultValue: Int = 0) -> Int {
    if let value = self.gameStateValues[key] as? Int {
      return value
    }
    return defaultValue
  }
  
  // Subscribes a GameStateListener to listen to the state variable identified by the given key. Whenever this state variable is updated, the listener will be notified via the reportStateChange method.
  func subscribe(_ listener: GameStateListener, to key: String) {
    if var listeners = self.gameStateListeners[key] {
      listeners.append(listener)
    } else {
      self.gameStateListeners[key] = [listener]
    }
  }
}
