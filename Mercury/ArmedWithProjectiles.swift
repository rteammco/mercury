//
//  Weaponized.swift
//  Mercury
//
//  Created by Richard Teammco on 4/5/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The Weaponized protocol enables implementing objects to fire bullets and other weapons.

import Foundation

protocol ArmedWithProjectiles {
  
  // Bullet firing (standard weapon) actions.
  func startFireBulletTimer()
  func stopFireBulletTimer()
  func fireBullet()
  
}
