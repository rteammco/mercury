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
  
  // Returns the same vector scaled by the given scalar.
  static func scaleVector(_ vector: CGVector, by scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
  }
  
  // Returns the distance (L2) between the given points.
  static func getDistance(between point1: CGPoint, and point2: CGPoint) -> CGFloat {
    let dx = point2.x - point1.x
    let dy = point2.y - point1.y
    return sqrt(dx * dx + dy * dy)
  }
  
  //------------------------------------------------------------------------------
  // Random value methods.
  //------------------------------------------------------------------------------
  
  // Returns a uniform random value (as a CGFloat) between the values in the given range (which is between 0 and 1 by default).
  static func getUniformRandomValue(between lowerBound: CGFloat = 0.0, and upperBound: CGFloat = 1.0) -> CGFloat {
    let range = abs(upperBound - lowerBound)
    return lowerBound + range * CGFloat(Float(arc4random()) / Float(UINT32_MAX))
  }
  
  // Returns a random 2D unit vector. This can be used for things such as randomizing an impulse direction.
  static func getRandomUnitVector() -> CGVector {
    let dx = getUniformRandomValue(between: -1, and: 1)
    let dy = getUniformRandomValue(between: -1, and: 1)
    return getNormalizedVector(CGVector(dx: dx, dy: dy))
  }
  
  // Returns a random point in the given rectangle, uniformly sampled.
  static func getRandomPointInRectangle(_ rectangle: CGRect) -> CGPoint {
    let randX = Util.getUniformRandomValue(between: rectangle.minX, and: rectangle.maxX)
    let randY = Util.getUniformRandomValue(between: rectangle.minY, and: rectangle.maxY)
    return CGPoint(x: randX, y: randY)
  }
  
  //------------------------------------------------------------------------------
  // Specific game methods.
  //------------------------------------------------------------------------------
  
  // Returns the player position within the game world. This position might be scaled due to a difference in the screen width vs. the game world width.
  static func getPlayerPosition(fromGameState gameState: GameState) -> CGPoint {
    let position = gameState.getPoint(forKey: .playerPosition)
    let scale = gameState.getCGFloat(forKey: .playerPositionXScaling, defaultValue: 1.0)
    let scaledPosition = CGPoint(x: position.x * scale, y: position.y)
    return scaledPosition
  }
  
}
