//
//  EventAction.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

class EventAction {
  
  var caller: EventProtocol?
  
  func setCaller(to caller: EventProtocol) {
    self.caller = caller
  }
  
  func execute() {
    
  }
  
}
