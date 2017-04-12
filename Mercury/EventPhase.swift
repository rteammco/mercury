//
//  EventPhase.swift
//  Mercury
//
//  Created by Richard Teammco on 3/27/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An EventPhase is a series of events and conditioned actions that can be executed as a single phase of a level (managed by a GameScene). Phases can be chained, allowing for a complex series of changing event-driven mechanics.


class EventPhase: EventAction, EventCaller {
  
  let gameScene: GameScene
  
  // All events and actions are stored and executed/started once the phase begins (in the order that they were added).
  var events: [Event]
  var actions: [EventAction]
  
  // The number of completed events. When all events are finished, this phase is done.
  var numCompletedEvents: Int
  
  // The next phase. If this is set (with setNextPhase), it will be started after this phase is finished.
  var nextPhase: EventPhase?
  
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    self.events = [Event]()
    self.actions = [EventAction]()
    self.numCompletedEvents = 0
  }
  
  //------------------------------------------------------------------------------
  // Methods for chaining event phases.
  //------------------------------------------------------------------------------
  
  // Set the next phase. This next EventPhase will be started once this EventPhase is finished.
  func setNextPhase(to nextPhase: EventPhase) {
    self.nextPhase = nextPhase
  }
  
  // Start the phase. This will begin all events in this phase and execute all initial actions.
  func start() {
    for event in self.events {
      event.finally(self)
      event.start()
    }
    for action in self.actions {
      action.execute()
    }
  }
  
  // This also poses as an EventAction. When any event part of this phase is completed, it "executes" this phase. The phase tracks the number of events that "executed" it, indicating that they finished. The phase ends when all of its events finish.
  override func execute() {
    self.numCompletedEvents += 1
    if self.numCompletedEvents >= self.events.count {
      finishPhase()
    }
  }
  
  // If the nextPhase is set, it gets started.
  private func finishPhase() {
    if let nextPhase = self.nextPhase {
      nextPhase.start()
    }
  }
  
  //------------------------------------------------------------------------------
  // Methods for EventCaller protocol.
  //------------------------------------------------------------------------------
  
  func when(_ event: Event) -> Event {
    event.setCaller(to: self.gameScene)
    self.events.append(event)
    return event
  }
  
  func execute(action: EventAction) {
    action.setCaller(to: self.gameScene)
    self.actions.append(action)
  }
  
}
