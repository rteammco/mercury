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
    return Util.getNormalizedVector(CGVector(dx: pointB.x - pointA.x, dy: pointB.y - pointA.y))
  }
  
  // Returns the rotation value given a direction vector.
  static func getOrientation(of vector: CGVector) -> CGFloat {
    return atan2(vector.dy, vector.dx)
  }
  
  // Returns a uniform random value (as a CGFloat) between the values in the given range (which is between 0 and 1 by default).
  static func getUniformRandomValue(between lowerBound: CGFloat = 0.0, and upperBound: CGFloat = 1.0) -> CGFloat {
    let range = abs(upperBound - lowerBound)
    return lowerBound + range * CGFloat(Float(arc4random()) / Float(UINT32_MAX))
  }
  
}
