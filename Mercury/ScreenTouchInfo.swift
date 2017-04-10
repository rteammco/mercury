//
//  ScreenTouchData.swift
//  Mercury
//
//  Created by Richard Teammco on 3/11/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  This object reports

import SpriteKit

struct ScreenTouchInfo {
  
  // The (absolute) pixel position on the screen that was touched.
  let touchPosition: CGPoint
  
  // The nodes (if any) that were touched.
  let touchedNodes: [SKNode]
  
  init(_ touchPosition: CGPoint, _ touchedNodes: [SKNode]) {
    self.touchPosition = touchPosition
    self.touchedNodes = touchedNodes
  }
}
