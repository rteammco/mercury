//
//  ButtonNode.swift
//  Mercury
//
//  Created by Richard Teammco on 4/16/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A ButtonNode is an SKLabelNode with added callback functionality and default factory methods to easily build and use buttons with custom action code. These buttons can be used inside scenes or in menus.

import SpriteKit

class ButtonNode: SKLabelNode {
  
  private var callbackFunction: (() -> Void)?
  
  // Create a smaller interface button.
  static func interfaceButton(withText text: String) -> ButtonNode {
    let buttonNode = ButtonNode(withText: text)
    buttonNode.fontName = GameConfiguration.secondaryFont
    buttonNode.fontSize = GameConfiguration.secondaryFontSize
    buttonNode.fontColor = GameConfiguration.secondaryColor
    return buttonNode
  }
  
  // Standard constructor. Use this one.
  init(withText text: String) {
    super.init()
    self.text = text
    self.verticalAlignmentMode = .center
    self.isUserInteractionEnabled = true
  }
  
  // Swift complains if these constructors aren't there.
  override init() {  // Runtime error if not present
    super.init()
  }
  required init(coder aDecoder: NSCoder) {  // Compile error if not present.
    fatalError("init(coder:) has not been implemented")
  }
  
  // Set the callback function.
  func setCallback(to callbackFunction: @escaping () -> Void) {
    self.callbackFunction = callbackFunction
  }
  
  // When touched, the callback function is called.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let callbackFunction = self.callbackFunction {
      callbackFunction()
    }
  }
  
}
