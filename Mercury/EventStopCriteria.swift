//
//  EventStopCriteria.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

class EventStopCriteria {
  
  var caller: EventProtocol?
  
  func setCaller(to caller: EventProtocol) {
    self.caller = caller
  }
  
  func isSatisfied() -> Bool {
    return true  // TODO
  }
  
}
