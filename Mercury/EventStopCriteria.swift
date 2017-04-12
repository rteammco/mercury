//
//  EventStopCriteria.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The EventStopCriteria is designed to inform an Event object whether a condition is satisfied that would stop the event from looping. This is NOT intended to stop an event before it triggers; rather it is intended as a loop stop criteria.


// Standard use case - this executes SomeEventAction every second until SomeEventStopCriteria.isSatisfied returns true:
//   when(TimerEvent(seconds: 1)).execute(SomeEventAction()).until(SomeEventStopCriteria())
protocol EventStopCriteria {
  
  // Sets the caller, which is often involved in determining whether a condition is satisfied.
  func setCaller(to caller: GameScene)
  
  // Returns true if the condition to stop the Event is satisfied.
  func isSatisfied() -> Bool
  
}


// A basic trivial implementation. This allows an Event to set the caller. Override the isSatisfied method.
class EventStopper: EventStopCriteria {
  
  var caller: GameScene?
  
  func setCaller(to caller: GameScene) {
    self.caller = caller
  }
  
  // Override as needed.
  func isSatisfied() -> Bool {
    return true
  }
  
}
