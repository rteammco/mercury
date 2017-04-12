//
//  GameScene.swift
//  Mercury
//
//  Created by Richard Teammco on 11/12/16.
//  Copyright © 2016 Richard Teammco. All rights reserved.
//
//  The GameScene controlls all of the sprites, animations, and physics in the app. It also handles user touch inputs.

import SpriteKit
import GameplayKit

class GameScene: SKScene, EventCaller, GameStateListener {
  
  // The contact delegate needs to be a local variable or else it disappears.
  private var contactDelegate: ContactDelegate?
  
  // The phase sequence that will be executed when this GameScene is started.
  private var eventPhaseSequence = [EventPhase]()
  
  // The size of the world used for scaling all displayed scene nodes.
  private var worldSize: CGFloat?
  
  // User touch interaction variables.
  private var lastTouchPosition: CGPoint?
  
  // Animation variables.
  private var lastFrameTime: TimeInterval?
  
  // Animation display objects.
  private var linePathNode: SKShapeNode?
  
  // GameState that keeps track of all of the game's state variables.
  private var gameState: GameState?
  
  //------------------------------------------------------------------------------
  // Scene initialization.
  //------------------------------------------------------------------------------
  
  // Called whenever the scene is presented into the view.
  override func didMove(to view: SKView) {
    // Set the size of the world based on the scene's size.
    self.worldSize = min(self.size.width, self.size.height)
    self.gameState = GameState()
    
    initializePhysics()
    initializeGameState()
    initializeScene()
  }
  
  // Set the contact delegate and disable gravity.
  private func initializePhysics() {
    self.contactDelegate = ContactDelegate()
    self.physicsWorld.contactDelegate = self.contactDelegate!
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
  }
  
  // Initializes values in the GameState. Eventually, this will load data from saved state values in the database.
  private func initializeGameState() {
    let gameState = getGameState()
    // TODO: These values should be adjusted from a database or some configuration file.
    gameState.setInt(.totalPlayerExperience, to: 0)
    gameState.setCGFloat(.playerHealth, to: 1000)
    gameState.setCGFloat(.playerBulletDamage, to: 10)
    gameState.setTimeInterval(.playerBulletFireInterval, to: 0.1)
    gameState.setCGFloat(.enemyHealthBase, to: 250)
    gameState.setCGFloat(.enemyBulletDamage, to: 5)
    gameState.setTimeInterval(.enemyBulletFireInterval, to: 0.1)
  }
  
  // Initialize the current level scene by setting up all GameObjects and events. By default, initializes the background node and subscribes to state changes. Extend as needed.
  func initializeScene() {
    // TODO: Create a good background node.
    subscribeToStateChanges()
  }
  
  // Add the player object to the scene (optional).
  func createPlayer(atPosition position: CGPoint) {
    let player = Player(position: getScaledPosition(position), gameState: getGameState())
    addGameObject(player)
    when(PlayerDies()).execute(action: DisplayText("Player Died"))  // TODO: Add an action that will handle this.
  }
  
  // Add the standard GUI to the scene (optional).
  func createGUI() {
    let hud = LevelHud(gameState: getGameState())
    addGameObject(hud)
  }
  
  //------------------------------------------------------------------------------
  // General level methods.
  //------------------------------------------------------------------------------
  
  // Adds the given GameObject type to the scene by appending its node. The object is automatically scaled according to the screen size.
  // Set withPhysicsScaling to true if the object is a PhysicsEnabledGameObject and its physical properties should be scaled to reflect the world size.
  func addGameObject(_ gameObject: GameObject, withPhysicsScaling: Bool = false) {
    if let worldSize = self.worldSize {
      let sceneNode = gameObject.createGameSceneNode(scale: worldSize)
      gameObject.connectToSceneNode(sceneNode)
      sceneNode.name = gameObject.nodeName
      if withPhysicsScaling {
        gameObject.scaleMovementSpeed(getScaleValue())
        if let physicsEnabledGameObject = gameObject as? PhysicsEnabledGameObject {
          physicsEnabledGameObject.scaleMass(by: getScaleValue())
        }
      }
      addChild(sceneNode)
    }
  }
  
  // Displays text on the screen that disappears after a few seconds. Optionally set the forDuration and withFadeOutDuration values (both in seconds) to change how long the text is displayed or how long it can fade out over. These values can be 0.
  func displayTextOnScreen(message: String, forDuration textOnScreenDuration: TimeInterval = 1, withFadeOutDuration textFadeOutDuration: TimeInterval = 1) {
    let labelNode = SKLabelNode(text: message)
    labelNode.fontName = GameConfiguration.mainFont
    labelNode.fontSize = GameConfiguration.mainFontSize
    labelNode.fontColor = GameConfiguration.primaryColor
    labelNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    addChild(labelNode)
    
    let waitBeforeFade = SKAction.wait(forDuration: textOnScreenDuration)
    let textFadeOut = SKAction.run({
      () in labelNode.run(SKAction.fadeOut(withDuration: textFadeOutDuration))
    })
    let waitBeforeRemove = SKAction.wait(forDuration: textFadeOutDuration)
    let removeTextNode = SKAction.run({
      () in labelNode.run(SKAction.removeFromParent())
    })
    run(SKAction.sequence([waitBeforeFade, textFadeOut, waitBeforeRemove, removeTextNode]))
  }
  
  // Returns a scaled version of the given normalized position. Position (0, 0) is in the center. If the X coordinate is -1, that's the left-most side of the screen; +1 is the right-most side. Since the screen is taller than it is wide, +/-1 in the Y axis is not going to be completely at the bottom or top.
  func getScaledPosition(_ normalizedPosition: CGPoint) -> CGPoint {
    let halfScaleValue = getScaleValue() / 2.0
    return CGPoint(x: halfScaleValue * normalizedPosition.x, y: halfScaleValue * normalizedPosition.y)
  }
  
  // Given a normalized value (e.g. speed), returns the absolute speed by scaling it up with the size of the world (which is dictated by the screen size of the device).
  func getScaledValue(_ normalizedValue: CGFloat) -> CGFloat {
    return normalizedValue * getScaleValue()
  }
  
  // Returns the scale value (not a scaled value, but rather the scaling factor itself).
  func getScaleValue() -> CGFloat {
    if let worldSize = self.worldSize {
      return worldSize
    }
    return 1.0
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
  
  // Returns the GameState for this GameScene. This GameState contains all game state variables and should be updated by any and all objects that need to set their variables to the global game state for Events and other objects to reference.
  func getGameState() -> GameState {
    if let gameState = self.gameState {
      return gameState
    } else {
      let gameState = GameState()
      self.gameState = gameState
      return gameState
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
  
  //------------------------------------------------------------------------------
  // Events and phasing methods.
  //------------------------------------------------------------------------------
  
  // Creates a new EventPhase with this GameScene as the parent.
  func createEventPhase() -> EventPhase {
    let phase = EventPhase(gameScene: self)
    return phase
  }
  
  // Adds a sequence of phases to the level, starting the first phase.
  func setPhaseSequence(_ phaseSequence: EventPhase...) {
    self.eventPhaseSequence = phaseSequence
    if self.eventPhaseSequence.count > 1 {
      for i in 1 ..< self.eventPhaseSequence.count {
        self.eventPhaseSequence[i - 1].setNextPhase(to: self.eventPhaseSequence[i])
      }
    }
  }
  
  // Starts the level, triggering the first phase.
  func start(withCountdown countdownTime: Int = 0) {
    if countdownTime > 0 {
      let countdownPhase = CountdownPhase(withDuration: countdownTime, gameScene: self)
      if !self.eventPhaseSequence.isEmpty {
        countdownPhase.setNextPhase(to: self.eventPhaseSequence.first!)
      }
      self.eventPhaseSequence.insert(countdownPhase, at: 0)
    }
    
    // Add the finish phase, which handles moving on to the next GameScene.
    // TODO: This should allow chaining levels, instead of always going to the main menu.
    let finishLevelPhase = createEventPhase()
    finishLevelPhase.execute(action: SetGameScene(to: "main menu"))
    self.eventPhaseSequence.last?.setNextPhase(to: finishLevelPhase)
    self.eventPhaseSequence.append(finishLevelPhase)
    
    self.eventPhaseSequence.first?.start()
  }
  
  //------------------------------------------------------------------------------
  // Touch event methods.
  //------------------------------------------------------------------------------
  
  private func touchDown(atPoint pos: CGPoint) {
    let touchedNodes: [SKNode] = nodes(at: pos)
    self.gameState?.inform(.screenTouchDown, value: ScreenTouchInfo(pos, touchedNodes))
    self.lastTouchPosition = pos
  }
  
  private func touchMoved(toPoint pos: CGPoint) {
    let touchedNodes: [SKNode] = nodes(at: pos)
    self.gameState?.inform(.screenTouchMoved, value: ScreenTouchInfo(pos, touchedNodes))
    self.lastTouchPosition = pos
  }
  
  private func touchUp(atPoint pos: CGPoint) {
    let touchedNodes: [SKNode] = nodes(at: pos)
    self.gameState?.inform(.screenTouchUp, value: ScreenTouchInfo(pos, touchedNodes))
  }
  
  //------------------------------------------------------------------------------
  // Scene management and cleanup methods.
  //------------------------------------------------------------------------------
  
  // Removes all nodes that are no longer on the screen. For example, if a bullet flies off the screen, there is no reason to track or update it anymore. It's gone.
  private func removeOffscreenNodes() {
    removeOffscreenNodes(from: self)
  }
  // Helper method for removeOffscreenNodes() above.
  private func removeOffscreenNodes(from parentNode: SKNode) {
    parentNode.enumerateChildNodes(withName: "bullet", using: { (node, stop) -> Void in
      if !parentNode.intersects(node) {
        if let gameObject = node.userData?.value(forKey: GameObject.nodeValueKey) as? GameObject {
          gameObject.destroyObject()
        }
      }
    })
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
    self.removeOffscreenNodes()
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
  
  //------------------------------------------------------------------------------
  // Methods for EventCaller protocol.
  //------------------------------------------------------------------------------
  
  func when(_ event: Event) -> Event {
    event.setCaller(to: self)
    event.start()
    return event
  }
  
  func execute(action: EventAction) {
    action.setCaller(to: self)
    action.execute()
  }
  
  //------------------------------------------------------------------------------
  // Methods for GameStateListener protocol.
  //------------------------------------------------------------------------------
  
  // Subscribe this GameScene to all relevant game state changes that it needs to handle. Extend as needed with custom subscriptions for a given level.
  func subscribeToStateChanges() {
    let gameState = getGameState()
    gameState.subscribe(self, to: .spawnPlayerBullet)
    gameState.subscribe(self, to: .spawnEnemyBullet)
    gameState.subscribe(self, to: .createParticleEffect)
  }

  // When a game state change is reported, handle it here. Extend as needed with custom handlers for a given level.
  //
  // TODO: Some of these might work better as separate functions, specific EventActions that handle all the mechanics, or even factory objects to make the code cleaner.
  func reportStateChange(key: GameStateKey, value: Any) {
    // Add spawned physics-enabled objects to the game.
    if key == .spawnPlayerBullet || key == .spawnEnemyBullet {
      if let gameObject = value as? PhysicsEnabledGameObject {
        addGameObject(gameObject, withPhysicsScaling: true)
        gameObject.setDefaultVelocity()
      }
    }
    // Add particle effects nodes.
    if key == .createParticleEffect {
      if let emitter = value as? SKEmitterNode {
        emitter.targetNode = self
        addChild(emitter)
      }
    }
  }
  
}
