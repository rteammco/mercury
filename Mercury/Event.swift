//
//  Event.swift
//  Mercury
//
//  Created by Richard Teammco on 1/24/17.
//  Copyright © 2017 Richard Teammco. All rights reserved.
//
//  The Event system provides a standard interface for events to trigger when a condition is satisfied. The Event system provides event chaining, looping, and a standard way of implementing event calls. This event system in part provides high readability in the way event calls are organized.


// An EventCaller is a protocol for any object that can start an event.
// Standard implementation:
//   func when(_ event: Event) -> Event {
//     event.setCaller(this)
//     event.start()
//     return event
//   }
//   func execute(action: EventAction) {
//     action.setCaller(to: self)
//     action.execute()
//   }
protocol EventCaller {
  func when(_ event: Event) -> Event
  func execute(action: EventAction)
}


// An Event object triggers after some condition is satisfied. It can also take the form of an EventStopCriteria, allowing it to act as a stop condition for other events.
// Example event call (in an object implemeting the EventCaller protocol):
//   when(TimerEvent(seconds: 10)).execute(DisplayText(message: "Hello, world"))
class Event: EventStopCriteria, GameStateListener {
  
  // Actions to be executed any time the event triggers.
  var eventActions: [EventAction]
  
  // Actions and event (both optional) to be executed and started when event is completely done, and stops repeating.
  var eventFinishedActions: [EventAction]
  var nextEvent: Event?
  
  // Actions that are executed when the event chain is completed. These are not necessarily executed when this particular event is finished, since they can be passed down to the next event in the chain.
  var eventChainFinalActions: [EventAction]
  
  var caller: GameScene?
  var stopCriteria: EventStopCriteria?
  
  var wasTriggered: Bool
  
  // An inactive event cannot be triggered. Use stop() to inactivate.
  var isActive: Bool
  
  // Once this event is subscribed to GameState changes, this flag is flipped to true. This way, if the event is reset, it will not re-subscribe itself to those state changes again.
  var isSubscribedToGameStateChanges: Bool
  
  init() {
    self.eventActions = [EventAction]()
    self.eventFinishedActions = [EventAction]()
    self.eventChainFinalActions = [EventAction]()
    self.wasTriggered = false
    self.isActive = true
    self.isSubscribedToGameStateChanges = false
  }
  
  func setCaller(to caller: GameScene) {
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
  
  // This is just for readability, so you can execute an event that does nothing when it triggers. This can be useful for event chaining. For example, you could set up a timer that just waits for a few seconds before the next event kicks in:
  // when(TimerFires(afterSeconds: 5)).doNothing().then(when: EnemyDies()).execute(action: ...)
  @discardableResult func doNothing() -> Event {
    return self
  }
  
  // After triggering, this event will reset and restart repeatedly until the given criteria is met.
  // TODO: allow mutliple stop criteria under AND or OR combinations, or create a special EventStopCriteria objects to handle these more advanced conditions.
  @discardableResult func until(_ stopCriteria: EventStopCriteria) -> Event {
    if let caller = self.caller {
      stopCriteria.setCaller(to: caller)
    }
    self.stopCriteria = stopCriteria
    return self
  }
  
  // After this event is complete (that is, all criteria are satisfied and the event is not repeating), the given action(s) will be executed. For example:
  // when(EnemyDies()).execute(SpawnEnemy()).until(NumberOfEnemiesSpawned(equals: 10)).then(DisplayText("You Win!"))
  @discardableResult func then(_ nextActions: EventAction...) -> Event {
    for action in nextActions {
      if let caller = self.caller {
        action.setCaller(to: caller)
      }
      self.eventFinishedActions.append(action)
    }
    return self
  }
  
  // After this event is complete, including any/all repeats, the given new Event will be started. This allows chaining events together. For example:
  // when(EnemyDies()).execute(SpawnEnemy()).until(NumberOfEnemiesSpawned(equals: 10)).then(when: TimerEvent(seconds: 10)).execute(DisplayText("You Won!"))
  @discardableResult func then(when nextEvent: Event) -> Event {
    if let caller = self.caller {
      nextEvent.setCaller(to: caller)
    }
    self.nextEvent = nextEvent
    return nextEvent
  }
  
  // Set actions that will be executed at the end of the event chain. If this is the last Event in a sequence of events, these actions will be executed when this event triggers. Otherwise, they will be executed when the last event in the sequence is triggered.
  // Event chains are constructed using the "then(when: NextEvent())..." method.
  func finally(_ eventChainFinalActions: EventAction...) {
    self.eventChainFinalActions = eventChainFinalActions
  }
  
  
  // Executes all the actions to be performed when the event occurs.
  func trigger(withOptionalValue optionalValue: Any? = nil) {
    if !self.isActive {
      return
    }
    self.wasTriggered = true
    // Run the actions, but verify that a stop criteria wasn't satisfied already.
    var canExecuteActions = true
    if let stopCriteria = self.stopCriteria {
      if stopCriteria.isSatisfied() {
        canExecuteActions = false
      }
    }
    if canExecuteActions {
      for action in self.eventActions {
        action.execute(withOptionalValue: optionalValue)
      }
    }
    // If a stop criteria was given and it is not yet satisfied after the actions were executed, reset the event and run it again.
    var willEventRepeat = false
    if let stopCriteria = self.stopCriteria {
      if !stopCriteria.isSatisfied() {
        willEventRepeat = true
      }
    }
    if willEventRepeat {
      start()
    } else if self.stopCriteria == nil || !canExecuteActions {
      // If event is not repeating or has no stop criteria (thus cannot repeat at all), finish off any final actions set with the "then" method, and start the next event if it was set.
      for action in self.eventFinishedActions {
        action.execute(withOptionalValue: optionalValue)
      }
      if let nextEvent = self.nextEvent {
        nextEvent.eventChainFinalActions.append(contentsOf: self.eventChainFinalActions)
        nextEvent.start()
      } else {
        // If this is the last event in a chain, execute any remaining actions that carried over from the start of the event chain.
        for action in self.eventChainFinalActions {
          action.execute(withOptionalValue: optionalValue)
        }
      }
    }
  }
  
  // If an Event serves as an EventStopCriteria, it is marked as satisfied after the event is triggered.
  func isSatisfied() -> Bool {
    return self.wasTriggered
  }
  
  // Subscribes this event to the given set of keys. This will only work the first time it is called. Use this method in the start() method instead of directly subscribing to GameState changes for optimal results.
  func subscribeTo(stateChanges keys: GameStateKey...) {
    // NOTE: We block the subscribe changes because start() typically runs the subscriptions, and start() is called in event loops.
    if !self.isSubscribedToGameStateChanges {
      for key in keys {
        GameScene.gameState.subscribe(self, to: key)
      }
      self.isSubscribedToGameStateChanges = true
    }
  }
  
  //------------------------------------------------------------------------------
  // The following methods need to be implemented by each Event object.
  //------------------------------------------------------------------------------
  
  // Starts the event. The event typically won't do anything until start is called. This should be called every time after an event is reset and re-started as well.
  func start() {
    self.wasTriggered = false
    self.isActive = true
    // Extend as needed, e.g. start a clock timer, and once it's done, call self.trigger(). Initialize all variables for the event here.
  }
  
  // Stop the event from firing.
  func stop() {
    // Extend as needed, e.g. by forcing a timer to stop, etc.
    self.isActive = false
  }
  
  // Reset the event. This will reset its execution state to the default values. Use this when the phase or level is reset.
  //
  // NOTE: Do not call reset() in start(), because start() is executed every time a repeating event loops. The state should NOT be reset during that time.
  func reset() {
    self.wasTriggered = false
    self.isActive = true
    self.isSubscribedToGameStateChanges = false
  }
  
  //------------------------------------------------------------------------------
  // State change method for the GameStateListener protocol.
  //------------------------------------------------------------------------------
  
  // This is used by Events that need to subscribe to certain game state changes to trigger. Note that the game state variables need to be actively updated by the GameScene or other objects in order to work effectively.
  func reportStateChange(key: GameStateKey, value: Any) {
    // Override as needed.
  }
  
}
