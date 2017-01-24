//
//  EventProtocol.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//

protocol EventProtocol {
  func when(_ event: Event) -> Event
}
