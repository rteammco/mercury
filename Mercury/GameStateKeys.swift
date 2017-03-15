//
//  GameStateKeys.swift
//  Mercury
//
//  Created by Richard Teammco on 3/15/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A list of keys that are used for the GameState. All keys used in the global GameState are defined here. Keys are grouped and named according to the type of action they represent.
//
//  The keys are enumerated as strings to allow referencing the actual raw string value (the string of the enum variable name) so that keys can be processed using standard string methods.


enum GameStateKey: String {
  
  case screenTouchDown, screenTouchMoved, screenTouchUp
  
  case spawnPlayerBullet, spawnEnemy
  
  case numSpawnedEnemies
  
}
