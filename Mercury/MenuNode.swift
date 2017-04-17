//
//  Menu.swift
//  Mercury
//
//  Created by Richard Teammco on 4/17/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A MenuNode is an SKNode that displays and automatically organizes various menu buttons.

import SpriteKit

class MenuNode: SKShapeNode {
  
  var buttons: [ButtonNode]
  
  init(inFrame frame: CGRect, withBackgroundAlpha alpha: CGFloat = 0.0) {
    self.buttons = [ButtonNode]()
    super.init()
    
    self.path = CGPath(rect: frame, transform: nil)
    self.position = CGPoint(x: frame.midX, y: frame.midY)
    // TODO: The menu can be fancy with some kind of border.
    self.strokeColor = SKColor.black
    self.zPosition = GameScene.zPositionForGUI
    
    let backgroundNode = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
    backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
    backgroundNode.fillColor = SKColor.black
    backgroundNode.alpha = alpha
    addChild(backgroundNode)
  }
  
  // Swift complains if these constructors aren't there.
  override init() {  // Runtime error if not present.
    self.buttons = [ButtonNode]()
    super.init()
  }
  required init(coder aDecoder: NSCoder) {  // Compile error if not present.
    fatalError("init(coder:) has not been implemented")
  }
  
  // Add a new button to this menu.
  func add(button: ButtonNode) {
    addChild(button)
    buttons.append(button)
    organizeButtonPositions()
  }
  
  // Organizes the button positions so that they all line up in the menu.
  private func organizeButtonPositions() {
    guard self.buttons.count > 0 else {
      return
    }
    
    var totalHeight: CGFloat = 0
    for button in self.buttons {
      totalHeight += button.frame.height
    }
    totalHeight *= 1.5  // Account for padding between buttons.
    
    let heightPerButton = totalHeight / CGFloat(self.buttons.count)
    var buttonY = self.frame.midY + totalHeight / 2
    for button in self.buttons {
      button.position = CGPoint(x: self.frame.midX, y: buttonY)
      buttonY -= heightPerButton
    }
  }
  
}
