//
//  EventAction.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  An EventAction is something that gets executed after an Event is triggered. What it does is arbitrary and completely defined by the specific EventAction. This template gives the Event object a standard interface to run the EventAction(s) once it is triggered.

class EventAction {
  
  var caller: EventCaller?
  
  // Set the caller to the call of the event. The Event object should do this automatically. The user should have access the the EventProtocol object which initialized the Event.
  func setCaller(to caller: EventCaller) {
    self.caller = caller
  }
  
  // This method is called when an event is complete. The user should have access to the caller object.
  func execute() {
    // Override as needed.
  }
  
}
