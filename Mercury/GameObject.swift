//
//  GameObject.swift
//  Mercury
//
//  Created by Richard Teammco on 11/13/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The GameObject provides a collection of methods and properties shared by all visible objects that can exist in the game scene. This includes interactive nodes, such as the player or enemies, as well as non-interactive visual elements such as touch visualization effects.

import SpriteKit

class GameObject: GameStateListener {
  
  // This key is used to look up the GameObject reference from a game scene node (SKNode).
  // GameObject handles more complex game mechanics, so each node is set to track its own GameObject through its userData dictionary.
  static let nodeValueKey: String = "gameSceneNodeToGameObjectKey"
  
  // User interaction variable tracks if this object is currently being touched by the user or not.
  private var isTouched: Bool
  
  // Tracks any timers associated with this object that need to be cleaned up when the object is destroyed.
  private var timers: [Timer]
  
  // The scene node for animation and rendering.
  var gameSceneNode: SKNode?
  var position: CGPoint
  
  // The global game state used to communicate with other GameObjects and the scene.
  let gameState: GameState
  
  // How fast the object moves in the world.
  // This is a relative value and is scaled by the GameScene depending on the screen size. It should only ever be modified with scaleMovementSpeed().
  var movementSpeed: CGFloat = 1.0
  
  // The direction of the object's motion (unit vector, scaled by movementSpeed).
  // By default, this motion is towards the top of the screen. Modify as needed with setMovementDirection().
  var movementDirection = CGVector(dx: 0.0, dy: 1.0)
  
  // This node name is assigned to the sprite/shape nodes returned by getSceneNode(). Use an
  // identifier for detecting those nodes in the scene.
  var nodeName = "object"
  
  // Health of this GameObject. Typically, when health reaches zero, the object "dies". This behavior is determined for each GameObject individually.
  var health: CGFloat = 100
  
  //------------------------------------------------------------------------------
  // Initialization methods and functionality.
  //------------------------------------------------------------------------------
  
  // Create the object, and get the global GameState to communicate with other GameObjects and modules in the scene.
  init(position: CGPoint, gameState: GameState) {
    self.isTouched = false
    self.timers = [Timer]()
    self.position = position
    self.gameState = gameState
  }
  
  // Scale the movement speed by the given non-negative value.
  func scaleMovementSpeed(_ speedScale: CGFloat) {
    // Speed must be non-negative.
    if speedScale >= 0 {
      self.movementSpeed *= speedScale
    }
  }
  
  // Creates the Sprite node that gets added to the GameScene. The given scale is based on the size of the screen, so the node's size should adapt according to the screen size. The position is in absolute coordinates.
  // Override as needed. By default, creates a blue square of (relative) size 0.5 which is about a third of the screen's width.
  // Called in GameObject's init().
  func createGameSceneNode(scale: CGFloat) -> SKNode {
    // Override as needed.
    let size = 0.15 * scale
    let node = SKShapeNode.init(rectOf: CGSize.init(width: size, height: size))
    node.position = position
    node.fillColor = SKColor.blue
    self.gameSceneNode = node
    return node
  }
  
  // Connects this GameObject to an SKNode (ideally its own) through the node's userData dictionary. This will allow the game to keep track of the GameObject (which likely has functionality for more advanced game mechanics).
  // Call this AFTER calling createGameSceneNode, and BEFORE adding it to the game scene. This should be handled automatically by GameScene's addGameObject method.
  func connectToSceneNode(_ gameSceneNode: SKNode) {
    if gameSceneNode.userData == nil {
      gameSceneNode.userData = NSMutableDictionary()
    }
    gameSceneNode.userData?.setValue(self, forKey: GameObject.nodeValueKey)
  }
  
  //------------------------------------------------------------------------------
  // Node operations (after node is added to the scene).
  //------------------------------------------------------------------------------
  
  // Returns the scene node for this object. If it was not initialized, the returned object will be an empty SKShapeNode.
  func getSceneNode() -> SKNode {
    if let gameSceneNode = self.gameSceneNode {
      return gameSceneNode
    } else {
      return SKShapeNode()
    }
  }
  
  // Removes this object's scene node from the game scene.
  func removeSceneNodeFromGameScene() {
    self.gameSceneNode?.removeFromParent()
  }
  
  //------------------------------------------------------------------------------
  // Movement methods.
  //------------------------------------------------------------------------------
  
  // Set the movement direction. This will automatically normalize the given vector (must be non-zero).
  func setMovementDirection(dx: CGFloat, dy: CGFloat) {
    let norm = sqrt(dx * dx + dy * dy)
    // Cannot have a zero norm (divide by 0 error).
    if norm > 0 {
      self.movementDirection.dx = dx / norm
      self.movementDirection.dy = dy / norm
    }
  }
  
  // Moves the scene node by the given dx and dy instantly.
  func moveBy(dx: CGFloat, dy: CGFloat) {
    if let gameSceneNode = self.gameSceneNode {
      gameSceneNode.position = CGPoint(x: gameSceneNode.position.x + dx, y: gameSceneNode.position.y + dy)
    }
  }
  
  //------------------------------------------------------------------------------
  // Utility methods for generic GameObject functionality.
  //------------------------------------------------------------------------------
  
  // Starts a looped timer that calls the given function (wrapped in a Selector) - use #selector(objcFunction) - after every interval given passes. The given function must have no parameters and should have no return type.
  // Set fireImmediately to true if you would like the timer to call the method at time 0 as well.
  // The Timer is returned. Used the returned value to invalidate it when you're done.
  func startLoopedTimer(every intervalSeconds: TimeInterval, callbackFunctionSelector: Selector, fireImmediately: Bool = false) -> Timer {
    let timer = Timer.scheduledTimer(timeInterval: intervalSeconds, target: self, selector: callbackFunctionSelector, userInfo: nil, repeats: true)
    if fireImmediately {
      timer.fire()
    }
    timers.append(timer)
    return timer
  }
  
  //------------------------------------------------------------------------------
  // Methods for game mechanics and actions.
  //------------------------------------------------------------------------------
  
  // Called to destroy or "kill" the object, typically when it dies (health reaches zero).
  func destroyObject() {
    for timer in self.timers {
      timer.invalidate()
    }
    removeSceneNodeFromGameScene()
  }
  
  func reduceHeath(by amount: CGFloat) {
    self.health -= amount
    if self.health <= 0 {
      destroyObject()
    }
  }
  
  //------------------------------------------------------------------------------
  // Methods for GameStateListener protocol.
  //------------------------------------------------------------------------------
  
  // This will subscribe the GameObject to the default set of user interaction global state changes, namely touch events. Only call this if your object needs access to most of these events. Otherwise, it is recommended to subscribe it explicity to the ones it needs.
  func subscribeToUserInteractionStateChanges() {
    self.gameState.subscribe(self, to: .screenTouchDown)
    self.gameState.subscribe(self, to: .screenTouchMoved)
    self.gameState.subscribe(self, to: .screenTouchUp)
  }
  
  // Default handlers for the touch methods. Override to implement functionality.
  func touchDown(at: CGPoint) {}
  func touchMoved(to: CGPoint) {}
  func touchUp(at: CGPoint) {}
  
  // Extend this as needed to handle custom events. Call the superclass (this) implementation to handle any of the default state changes.
  func reportStateChange(key: GameStateKey, value: Any) {
    switch key {
    case .screenTouchDown:
      let touchInfo = value as! ScreenTouchInfo
      if touchInfo.touchedNode.name == self.nodeName {
        self.isTouched = true
        touchDown(at: touchInfo.touchPosition)
      }
    case .screenTouchMoved:
      if self.isTouched {
        let touchInfo = value as! ScreenTouchInfo
        touchMoved(to: touchInfo.touchPosition)
      }
    case .screenTouchUp:
      self.isTouched = false
      let touchInfo = value as! ScreenTouchInfo
      touchUp(at: touchInfo.touchPosition)
    default: break
    }
  }
}
