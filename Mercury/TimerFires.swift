//
//  TimerEvent.swift
//  Mercury
//
//  Created by Richard Teammco on 1/30/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  This is a standard timer event which takes as input a duration (in seconds). The event triggers when the duration expires.

import Foundation
import SpriteKit

class TimerFires: Event {
  
  private let timeInSeconds: CGFloat
  private var timer: Timer?
  
  // Set the time in seconds. This will fire the event exactly once after the given time.
  init(afterSeconds seconds: CGFloat) {
    self.timeInSeconds = seconds
    super.init()
  }
  
  // Starts the timer, which will trigger the event once the timer is done. This timer is set to not repeat since repeating timers are done as chained events.
  override func start() {
    self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timeInSeconds), target: self, selector: #selector(runTriggerFunction), userInfo: nil, repeats: false)
  }
  
  // Need to override this function with @objc to make it compatible with the Timer interface. Also invalidates the timer just in case.
  @objc func runTriggerFunction() {
    self.timer?.invalidate()
    trigger()
  }
  
}
