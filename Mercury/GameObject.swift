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
  
  // The scene node for animation and rendering.
  var gameSceneNode: SKNode?
  private var position: CGPoint
  
  // How fast the object moves in the world.
  // This is a relative value and is scaled by the GameScene depending on the screen size. It should only ever be modified with scaleMovementSpeed().
  var movementSpeed: CGFloat = 1.0
  
  // The direction of the object's motion (unit vector, scaled by movementSpeed).
  // By default, this motion is towards the top of the screen. Modify as needed with setMovementDirection().
  var movementDirection = CGVector(dx: 0.0, dy: 1.0)
  
  // This node name is assigned to the sprite/shape nodes returned by getSceneNode(). Use an
  // identifier for detecting those nodes in the scene.
  var nodeName = "object"
  
  // A guard to prevent destroyed objects from interacting with the game.
  private var destroyObjectCalled: Bool
  
  // The "health", or number of hit points (HP), of this GameObject. Typically, when HP reaches zero, the object "dies". This behavior is determined for each GameObject individually.
  // The maxHitPoints value is used to track the current percentage or ratio of health, and to track its maximum health amount. An object's hitPoints typically cannot exceed maxHitPoints or go below 0.
  private var hitPoints: CGFloat = 100
  private var maxHitPoints: CGFloat = 100
  
  //------------------------------------------------------------------------------
  // Initialization methods and functionality.
  //------------------------------------------------------------------------------
  
  // Create the object.
  init(position: CGPoint) {
    self.isTouched = false
    self.position = position
    self.destroyObjectCalled = false
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
    let size = GameConfiguration.smallObjectSize * scale
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
  
  // Returns the bounding box in which the node is contained.
  func getBoundingBox() -> CGRect {
    if let gameSceneNode = self.gameSceneNode {
      return gameSceneNode.calculateAccumulatedFrame()
    }
    return CGRect(x: 0, y: 0, width: 0, height: 0)
  }
  
  // Removes this object's scene node from the game scene.
  func removeSceneNodeFromGameScene() {
    self.gameSceneNode?.removeFromParent()
  }
  
  // Returns true if destroyObject() was previously called on this object.
  func wasDestroyed() -> Bool {
    return self.destroyObjectCalled
  }
  
  //------------------------------------------------------------------------------
  // Movement methods.
  //------------------------------------------------------------------------------
  
  // Set the movement direction. This will automatically normalize the given vector (must be non-zero).
  func setMovementDirection(to directionVector: CGVector) {
    self.movementDirection = Util.getNormalizedVector(directionVector)
  }
  
  // Returns the position of this object. Also updates the interal position of this object if it hasn't been updated to the node's latest position (if the node exists).
  func getPosition() -> CGPoint {
    if let node = self.gameSceneNode {
      self.position = node.position
    }
    return self.position
  }
  
  // Moves the scene node by the given dx and dy instantly.
  func move(by amount: CGVector) {
    if let gameSceneNode = self.gameSceneNode {
      self.position = CGPoint(x: self.position.x + amount.dx, y: self.position.y + amount.dy)
      gameSceneNode.position = self.position
    }
  }
  
  // If an external controller is moving this object (e.g. a GameObjectPath), it will notify the object using this method when movement is started.
  func notifyMotionStarted() {
    // Extend as needed.
    if let gameSceneNode = self.gameSceneNode {
      self.position = gameSceneNode.position
    }
  }
  
  // Similarly, when externally-controlled movement ends, this method will be called to notify the object that movement finished.
  func notifyMotionEnded() {
    // Extend as needed.
    if let gameSceneNode = self.gameSceneNode {
      self.position = gameSceneNode.position
    }
  }
  
  //------------------------------------------------------------------------------
  // Utility methods for generic GameObject functionality.
  //------------------------------------------------------------------------------
  
  // Starts a looped timer that calls the given function after every interval given passes. Set fireImmediately to true if you would like the timer to call the method at time 0 as well.
  func startLoopedTimer(withKey key: String, every intervalSeconds: TimeInterval, withCallback callbackFunction: @escaping (() -> Void), fireImmediately: Bool = false) {
    let wait = SKAction.wait(forDuration: intervalSeconds)
    let runCallback = SKAction.run(callbackFunction)
    var actionSequence = [SKAction]()
    if fireImmediately {
      actionSequence = [runCallback, wait]
    } else {
      actionSequence = [wait, runCallback]
    }
    let action = SKAction.repeatForever(SKAction.sequence(actionSequence))
    self.gameSceneNode?.run(action, withKey: key)
  }
  
  // Stops a looping timer with the given unique key.
  func stopLoopedTimer(withKey key: String) {
    self.gameSceneNode?.removeAction(forKey: key)
  }
  
  //------------------------------------------------------------------------------
  // Methods for game mechanics and actions.
  //------------------------------------------------------------------------------
  
  // Initialize the hit points of this object (and its max HP) to the given value. This should be called once to initialize the amount of hit points this object has.
  func initializeHitPoints(_ amount: CGFloat) {
    self.hitPoints = amount
    self.maxHitPoints = amount
  }
  
  // Update the health amount of this object. If health reaches 0, this object will automatically be destroyed. Health will not exceed maxHitPoints.
  // To reduce HP, pass in a negative value (e.g. obj.changeHitPoints(by: -10)).
  func changeHitPoints(by amount: CGFloat) {
    self.hitPoints += amount
    if self.hitPoints <= 0 {
      self.hitPoints = 0
      destroyObject()
    } else if self.hitPoints > self.maxHitPoints {
      self.hitPoints = self.maxHitPoints
    }
  }
  
  // Returns the number of HP this object currently has.
  func getHitPoints() -> CGFloat {
    return self.hitPoints
  }
  
  // Returns the max HP of this object.
  func getMaxHitPoints() -> CGFloat {
    return self.maxHitPoints
  }
  
  // Called to destroy or "kill" the object, typically when it dies (health reaches zero).
  func destroyObject() {
    self.destroyObjectCalled = true
    removeSceneNodeFromGameScene()
  }
  
  //------------------------------------------------------------------------------
  // Methods for GameStateListener protocol.
  //------------------------------------------------------------------------------
  
  // This will subscribe the GameObject to the default set of user interaction global state changes, namely touch events. Only call this if your object needs access to most of these events. Otherwise, it is recommended to subscribe it explicity to the ones it needs.
  func subscribeToUserInteractionStateChanges() {
    GameScene.gameState.subscribe(self, to: .screenTouchDown)
    GameScene.gameState.subscribe(self, to: .screenTouchMoved)
    GameScene.gameState.subscribe(self, to: .screenTouchUp)
  }
  
  // Default handlers for the touch methods. Override to implement functionality.
  func touchDown(at: CGPoint) {}
  func touchMoved(to: CGPoint) {}
  func touchUp(at: CGPoint) {}
  
  // Returns true if one of the nodes shares the same name as this node.
  private func isObjectOneOf(nodes: [SKNode]) -> Bool {
    for node in nodes {
      if node.name == self.nodeName {
        return true
      }
    }
    return false
  }
  
  // Extend this as needed to handle custom events. Call the superclass (this) implementation to handle any of the default state changes.
  func reportStateChange(key: GameStateKey, value: Any) {
    switch key {
    case .screenTouchDown:
      let touchInfo = value as! ScreenTouchInfo
      if isObjectOneOf(nodes: touchInfo.touchedNodes) {
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
  
  //------------------------------------------------------------------------------
  // Animation and adjustment updates.
  //------------------------------------------------------------------------------
  
  // Called every frame by the active GameScene.
  func update(elapsedTime timeSinceLastUpdate: TimeInterval) {
    // Override as needed.
  }
  
}
