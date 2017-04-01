//
//  CountdownPhase.swift
//  Mercury
//
//  Created by Richard Teammco on 4/1/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  A special EventPhase object that handles a countdown timer. The countdown just ticks seconds displayed on the screen, counting down from the given value to 1, over the given number of seconds.

class CountdownPhase: EventPhase {
  
  init(withDuration seconds: Int, parent: EventCaller) {
    super.init(parent: parent)
    if seconds > 0 {
      setupCountdown(countdownTime: seconds)
    }
  }
  
  private func setupCountdown(countdownTime: Int) {
    // The first countdown tick shows up immediately when the phase starts.
    execute(action: getDisplayTextAction(String(countdownTime)))
    if countdownTime > 1 {
      // The second tick shows up a second after the first.
      var counterString = String(countdownTime - 1)
      var event = when(TimerFires(afterSeconds: 1)).execute(action: getDisplayTextAction(counterString))
      // All other ticks (other than the first two) show up a second after the last event ticked.
      for counter in (1 ... (countdownTime - 2)).reversed() {
        counterString = String(counter)
        event = event.then(when: TimerFires(afterSeconds: 1)).execute(action: getDisplayTextAction(counterString))
      }
      // Finally, wait a second after the last event fires before finishing the phase (to give it time to fade out).
      event.then(when: TimerFires(afterSeconds: 1)).doNothing()
    } else {
      when(TimerFires(afterSeconds: 1)).doNothing()
    }
  }
  
  // Returns a 1-second text display action that fades out over the second.
  // TODO: This can be made into a more flashy animation.
  private func getDisplayTextAction(_ text: String) -> DisplayText {
    let action = DisplayText(text, forDuration: 0, withFadeOutDuration: 1)
    return action
  }
  
}
