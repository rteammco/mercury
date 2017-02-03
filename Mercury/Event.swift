//
//  Event.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The Event system provides a standard interface for events to trigger when a condition is satisfied. The Event system provides event chaining, looping, and a standard way of implementing event calls. This event system in part provides high readability in the way event calls are organized.


// An EventCaller is a protocol for any object that can start an event.
// Standard implementation:
//   func when(_ event: Event) -> Event {
//     event.setCaller(this)
//     event.start()
//     return event
//   }
protocol EventCaller {
  func when(_ event: Event) -> Event
}


// An Event object triggers after some condition is satisfied. It can also take the form of an EventStopCriteria, allowing it to act as a stop condition for other events.
// Example event call (in an object implemeting the EventCaller protocol):
//   when(TimerEvent(seconds: 10)).execute(DisplayTextAction(message: "Hello, world"))
class Event: EventStopCriteria {
  
  var eventActions: [EventAction]
  
  var caller: EventCaller?
  var stopCriteria: EventStopCriteria?
  var nextEvent: Event?
  
  var wasTriggered: Bool
  
  init() {
    self.eventActions = [EventAction]()
    self.wasTriggered = false
  }
  
  func setCaller(to caller: EventCaller) {
    self.caller = caller
  }
  
  // A single action to be performed when this event is triggered.
  @discardableResult func execute(action: EventAction) -> Event {
    if let caller = self.caller {
      action.setCaller(to: caller)
    }
    self.eventActions.append(action)
    return self
  }
  
  // A set of actions to be performed when this event is triggered.
  @discardableResult func execute(actions: EventAction...) -> Event {
    for action in actions {
      _ = execute(action: action)
    }
    return self
  }
  
  // After triggering, this event will reset and restart repeatedly until the given criteria is met.
  // TODO: allow mutliple stop criteria under AND or OR combinations, or create a special EventStopCriteria objects to handle these more advanced conditions.
  @discardableResult func until(_ stopCriteria: EventStopCriteria) -> Event {
    if let caller = self.caller {
      stopCriteria.setCaller(to: caller)
    }
    self.stopCriteria = stopCriteria
    return self
  }
  
  // After this event is complete (that is, all criteria are satisfied and the event is not repeating), the given event will be started next.
  @discardableResult func then(_ nextEvent: Event) -> Event {
    if let caller = self.caller {
      nextEvent.setCaller(to: caller)
    }
    return nextEvent
  }
  
  // Executes all the actions to be performed when the event occurs.
  func trigger() {
    for action in self.eventActions {
      action.execute()
    }
    self.wasTriggered = true
    // If a stop criteria was given and it is not yet satisfied, reset the event and run it again.
    var willEventRepeat = false
    if let stopCriteria = self.stopCriteria {
      if !stopCriteria.isSatisfied() {
        willEventRepeat = true
      }
    }
    if willEventRepeat {
      reset()
    } else if let nextEvent = self.nextEvent {
      nextEvent.start()
    }
  }
  
  // If an Event serves as an EventStopCriteria, it is marked as satisfied after the event is triggered.
  func isSatisfied() -> Bool {
    return self.wasTriggered
  }
  
  // Resets the Event and calls start() again to loop the event from the beginning. Any setup needed should be implemented in the start() method.
  private func reset() {
    self.wasTriggered = false
    start()
  }
  
  //------------------------------------------------------------------------------
  // The following methods need to be implemented by each Event object.
  //------------------------------------------------------------------------------
  
  // Starts the event. The event won't do anything until start is called. This will be called every time after an event is reset and re-started.
  func start() {
    // Override as needed, e.g. start a clock timer, and once it's done, call self.trigger(). Initialize all variables for the event here.
  }
  
}

// This extension is used by Events that need to subscribe to certain game state changes to trigger. Note that the game state variables need to be actively updated by the GameScene or other objects in order to work effectively.
extension Event: GameStateListener {
  func reportStateChange(key: String, value: Any) {
    // Override as needed.
  }
}
