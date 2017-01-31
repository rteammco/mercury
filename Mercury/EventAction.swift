//
//  EventAction.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

class EventAction {
  
  var caller: EventProtocol?
  
  // Set the caller to the call of the event. The Event object should do this automatically. The user should have access the the EventProtocol object which initialized the Event.
  func setCaller(to caller: EventProtocol) {
    self.caller = caller
  }
  
  // This method is called when an event is complete. The user should have access to the caller object.
  // Override as needed.
  func execute() {
    print("Event complete.")
  }
  
}
