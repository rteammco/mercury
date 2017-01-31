//
//  Event.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

class Event {
  
  /*
   EventProtocol obj
   event = obj.when(MyEvent()) -> MyEvent(obj)
   event = event.execute(action: MyEventAction()) -> MyEvent(obj)
   event = event.until(MyFinishCriteria()) -> MyEvent(obj)
   event2 = event.then(MyOtherEvent()) -> MyOtherEvent(obj)
   event.start()
   
   ==
   
   obj.when(MyEvent()).execute(action: MyEventAction()).until(MyFinishCriteria()).then(MyOtherEvent())
   
   when(e: Event) {
     e.setCaller(this)
     e.start()
     return e
   }
   */
  
  var eventActions: [EventAction]
  
  var caller: EventProtocol?
  var stopCriteria: EventStopCriteria?
  var nextEvent: Event?
  
  init() {
    self.eventActions = [EventAction]()
  }
  
  func setCaller(to caller: EventProtocol) {
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
  
  //------------------------------------------------------------------------------
  // The following methods need to be implemented by each Event object.
  //------------------------------------------------------------------------------
  
  // Starts the event. The event won't do anything until start is called.
  func start() {
    // Override as needed, e.g. start a clock timer, and once it's done, call self.trigger().
  }
  
  // Resets the event variables and calls start() again to loop the event from the beginning.
  func reset() {
    // Override as needed to reset any variables and start the event again.
    start()
  }
  
}

// This extension is used by Events that need to subscribe to certain game state changes to trigger. Note that the game state variables need to be actively updated by the GameScene or other objects in order to work effectively.
extension Event: GameStateListener {
  func reportStateChange(key: String, value: Any) {
    // Override as needed.
  }
}
