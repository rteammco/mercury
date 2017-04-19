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
  
  var menuItems: [SKLabelNode]
  
  init(inFrame frame: CGRect, withBackgroundAlpha alpha: CGFloat = 0.0) {
    self.menuItems = [SKLabelNode]()
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
    self.menuItems = [SKLabelNode]()
    super.init()
  }
  required init(coder aDecoder: NSCoder) {  // Compile error if not present.
    fatalError("init(coder:) has not been implemented")
  }
  
  // Add a new button to this menu.
  func add(button: ButtonNode) {
    button.fontName = GameConfiguration.menuButtonFont
    button.fontSize = GameConfiguration.menuButtonFontSize
    button.fontColor = GameConfiguration.menuButtonColor
    add(item: button)
  }
  
  // Add a new label node to this menu. Menu labels are generally non-interactable and their color is different.
  func add(label: SKLabelNode) {
    label.fontName = GameConfiguration.menuLabelFont
    label.fontSize = GameConfiguration.menuLabelFontSize
    label.fontColor = GameConfiguration.menuLabelColor
    label.isUserInteractionEnabled = false
    add(item: label, pushToTop: true)
  }
  
  // Generic add function to add any SKLabelNode (button or otherwise).
  private func add(item: SKLabelNode, pushToTop: Bool = false) {
    addChild(item)
    if pushToTop {
      self.menuItems.insert(item, at: 0)
    } else {
      self.menuItems.append(item)
    }
    organizeItemPositions()
  }
  
  // Organizes the button positions so that they all line up in the menu.
  private func organizeItemPositions() {
    guard self.menuItems.count > 0 else {
      return
    }
    
    var totalHeight: CGFloat = 0
    for button in self.menuItems {
      totalHeight += button.frame.height
    }
    totalHeight *= 2  // Account for padding between buttons.
    
    let heightPerItem = totalHeight / CGFloat(self.menuItems.count)
    var itemY = self.frame.midY + totalHeight / 2
    for item in self.menuItems {
      item.position = CGPoint(x: self.frame.midX, y: itemY)
      itemY -= heightPerItem
    }
  }
  
}
