//
//  EventPhase.swift
//  Mercury
//
//  Created by Richard Teammco on 3/27/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An EventPhase is a series of events and conditioned actions that can be executed as a single phase of a level (managed by a GameScene). Phases can be chained, allowing for a complex series of changing event-driven mechanics.


class EventPhase: EventAction, EventCaller {
  
  let parent: EventCaller
  
  // All events and actions are stored and executed/started once the phase begins (in the order that they were added).
  var events: [Event]
  var actions: [EventAction]
  
  // The number of completed events. When all events are finished, this phase is done.
  var numCompletedEvents: Int
  
  init(parent: EventCaller) {
    self.parent = parent
    self.events = [Event]()
    self.actions = [EventAction]()
    self.numCompletedEvents = 0
  }
  
  //------------------------------------------------------------------------------
  // Methods for chaining event phases.
  //------------------------------------------------------------------------------
  
  func start() {
    for event in self.events {
      event.then(self)
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
      print("PHASE FINISHED")
    }
  }
  
  //------------------------------------------------------------------------------
  // Methods for EventCaller protocol.
  //------------------------------------------------------------------------------
  
  func when(_ event: Event) -> Event {
    event.setCaller(to: self.parent)
    self.events.append(event)
    return event
  }
  
  func execute(action: EventAction) {
    action.setCaller(to: self.parent)
    self.actions.append(action)
  }
  
}
