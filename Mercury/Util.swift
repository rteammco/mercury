//
//  Util.swift
//  Mercury
//
//  Created by Richard Teammco on 4/6/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A bunch of utility functions used throughout the code.

import SpriteKit

struct Util {
  
  // Returns a normalized version of the given CGVector. If the vector is a zero-vector, it will be returned as-is.
  static func getNormalizedVector(_ vector: CGVector) -> CGVector {
    let norm = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
    if norm > 0 {
      return CGVector(dx: vector.dx / norm, dy: vector.dy / norm)
    }
    return vector
  }
  
  // Returns a normalized direction vector that points from pointA to pointB. If pointA = pointB, this will be the zero vector.
  static func getDirectionVector(from pointA: CGPoint, to pointB: CGPoint) -> CGVector {
    return Util.getNormalizedVector(CGVector(dx: pointA.x - pointB.x, dy: pointA.y - pointB.y))
  }
  
}
