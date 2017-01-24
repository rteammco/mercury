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
  func execute(action: EventAction) -> Event {
    if let caller = self.caller {
      action.setCaller(to: caller)
    }
    self.eventActions.append(action)
    return self
  }
  
  // A set of actions to be performed when this event is triggered.
  func execute(actions: EventAction...) -> Event {
    for action in actions {
      _ = execute(action: action)
    }
    return self
  }
  
  // After triggering, this event will reset and restart repeatedly until the given criteria is met.
  func until(_ stopCriteria: EventStopCriteria) -> Event {
    if let caller = self.caller {
      stopCriteria.setCaller(to: caller)
    }
    self.stopCriteria = stopCriteria
    return self
  }
  
  // After this event is complete (that is, all criteria are satisfied and the event is not repeating), the given event will be started next.
  func then(_ nextEvent: Event) -> Event {
    if let caller = self.caller {
      nextEvent.setCaller(to: caller)
    }
    return nextEvent
  }
  
  // Starts the event. The event won't do anything until start is called.
  func start() {
    // TODO
    // e.g. start a clock timer, and once it's done, call self.trigger()
  }
  
  // Resets the event.
  func reset() {
    // TODO
    // reset variables, and then call start() again
  }
  
  // Executes all the actions to be performed when the event occurs.
  private func trigger() {
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
  
}
