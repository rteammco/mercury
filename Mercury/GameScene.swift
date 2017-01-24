//
//  GameScene.swift
//  Mercury
//
//  Created by Richard Teammco on 11/12/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The GameScene controlls all of the sprites, animations, and physics in the app. It also handles user touch inputs. The Level instance that's currently being run handles all of the game logic, and works closely with the GameScene for detecting sprite interactions.

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  // Game units.
  var player: Player?
  var enemies: [Enemy]?
  var friendlyProjectiles: [GameObject]?
  
  // The size of the world used for scaling all displayed scene nodes.
  var worldSize: CGFloat?
  
  // User touch interaction variables.
  private var lastTouchPosition: CGPoint?
  
  // Animation variables.
  private var lastFrameTime: TimeInterval?
  
  // Animation display objects.
  private var linePathNode: SKShapeNode?
  
  //------------------------------------------------------------------------------
  // Scene initialization.
  //------------------------------------------------------------------------------
  
  // Called whenever the scene is presented into the view.
  override func didMove(to view: SKView) {
    // Set the size of the world based on the scene's size.
    self.worldSize = min(self.size.width, self.size.height)
    
    self.enemies = [Enemy]()
    self.friendlyProjectiles = [GameObject]()
    
    initializePhysics()
    initializeScene()
  }
  
  // Set the contact delegate and disable gravity.
  private func initializePhysics() {
    self.physicsWorld.contactDelegate = ContactDelegate()
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
  }
  
  // Add the player object to the scene (optional).
  func createPlayer(atPosition position: CGPoint) {
    let player = Player(position: getScaledPosition(position))
    addGameObject(player)
    self.player = player
  }
  
  // Initialize the current level scene by setting up all GameObjects and events.
  func initializeScene() {
    // Override function as needed.
    let testLevel = TestLevel()
    setCurrentLevel(to: testLevel)
  }
  
  //------------------------------------------------------------------------------
  // General level methods.
  //------------------------------------------------------------------------------
  
  // Adds the given GameObject type to the scene by appending its node.
  // In addition, scales the movement speed and Sprite node size of the GameObject by the world size to account for the size of the device screen. If scaleSpeed is set to false, the speed will not be scaled. This is useful for certain nodes such as the Player which are moved by user interaction, meaning the speed is already inherently scaled to the size/resolution of the screen.
  func addGameObject(_ gameObject: GameObject) {
    if let worldSize = self.worldSize {
      let sceneNode = gameObject.createGameSceneNode(scale: worldSize)
      addChild(sceneNode)
    }
  }
  
  // Sets the current GameScene to the object defined in the given GameScene file. This GameScene will be presented to the view.
  func setCurrentLevel(to nextLevel: GameScene) {
    if let view = self.view {
      // Copy the current GameScene's properties.
      nextLevel.size = self.size
      nextLevel.scaleMode = self.scaleMode
      nextLevel.anchorPoint = self.anchorPoint
      view.presentScene(nextLevel)
    }
  }
  
  /* TODO: we may not need these methods.
  // Returns the world's scaling factor that's used for objects to scale their graphics and other visualization or motion parameters.
  func getWorldScale() -> CGFloat {
    if let worldSize = self.worldSize {
      return worldSize  // This should always be defined.
    }
    return 1.0
  }
  
  // Returns a scaled version of the given normalized size (where a size of 1.0 is the width of the screen). The scaled version will reflect the pixel size of the screen.
  func getScaledSize(_ normalizedSize: CGSize) -> CGSize {
    if let worldSize = self.worldSize {
      return CGSize(width: worldSize * normalizedSize.width, height: worldSize * normalizedSize.height)
    }
    return normalizedSize
  }
   */
  
  // Returns a scaled version of the given normalized position. Position (0, 0) is in the center. If the X coordinate is -1, that's the left-most side of the screen; +1 is the right-most side. Since the screen is taller than it is wide, +/-1 in the Y axis is not going to be completely at the bottom or top.
  func getScaledPosition(_ normalizedPosition: CGPoint) -> CGPoint {
    if let worldSize = self.worldSize {
      let halfWorldSize = worldSize / 2.0
      return CGPoint(x: halfWorldSize * normalizedPosition.x, y: halfWorldSize * normalizedPosition.y)
    }
    return normalizedPosition
  }
  
  // Returns true if the given object is within screen bounds.
  func isGameObjectWithinScreenBounds(gameObject: GameObject) -> Bool {
    // TODO
    return true
  }
  
  // Returns the previous position on the screen that a user's touch occured.
  // The previous location is the one before the latest touch action. If no touch was previously recorded, returns (0, 0) which is the center of the screen.
  func getPreviousTouchPosition() -> CGPoint {
    if let previousTouchPosition = self.lastTouchPosition {
      return previousTouchPosition
    } else {
      return CGPoint(x: 0, y: 0)
    }
  }
  
  //------------------------------------------------------------------------------
  // Touch event methods.
  //------------------------------------------------------------------------------
  
  func touchDown(atPoint pos: CGPoint) {
    // TODO
    self.lastTouchPosition = pos
  }
  
  func touchMoved(toPoint pos: CGPoint) {
    // TODO
    self.lastTouchPosition = pos
  }
  
  func touchUp(atPoint pos: CGPoint) {
    // TODO
  }
  
  //------------------------------------------------------------------------------
  // Animation update methods.
  //------------------------------------------------------------------------------
  
  // This method measures the elapsed time since the last frame and updates the current game level.
  // Called before each frame is rendered with the current time.
  override func update(_ currentTime: TimeInterval) {
    // TODO
    //if let lastFrameTime = self.lastFrameTime {
    //  let elapsedTime = currentTime - lastFrameTime
    //}
    self.lastFrameTime = currentTime
  }
  
  //------------------------------------------------------------------------------
  // SKScene multitouch handlers.
  //------------------------------------------------------------------------------
  
  // Called when user starts a touch action.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  // Called when user moves (drags) during a touch action.
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  // Called when user finishes a touch action.
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  // Called when a touch action is interrupted or otherwise cancelled.
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
}
