//
//  SimpleStateMachine.swift
//  iOSScoreESports
//
//  Created by Jessica Ip on 2016-02-29.
//  Copyright © 2016 theScore. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 theScore Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



/*
*  This is a generic state machine that can be used to track state and transitions between them.
*  At all times, transitions will be determined based on the currently stored state and updated
*  using the transition method.
*
*  NOTE: You cannot set the currentState manually, the purpose is for the SM to track this automatically.
*        All transitions are handled by the SM to ensure correctness of the system.
*
*
*  This supports subscripting for assigning transitions, for example:
*
*  SimpleStateMachine[State1] =
*     [ Event1 : State2,
*       Event2 : State3 ]
*
*
*  Fictitious example:
*
*  SimpleStateMachine[introState] =
*      [ loginAction : termsAndConditionsVC,
*        facebookLoginAction : onboardingVC,
*        skipAction : dismissLogic ]
*
*
*/
public class SimpleStateMachine<State, Event where State: Hashable, Event: Hashable> {
	private(set) var currentState: State
	private var states: [State : [Event : State]] = [:]
	
	// MARK: - Init
	public init(initialState: State) {
		currentState = initialState
	}
	
	/**
	This simply uses the subscripting syntax to utilize shorthand notation to assign transitions to a given state.
	
	- parameter state: the state we want to get/set
	
	- returns: the associated transitions (event -> state) for the state parameter
	*/
	public subscript(state: State) -> [Event : State]? {
		get {
			return states[state]
		}
		set(transitions) {
			states[state] = transitions
		}
	}
	
	
	/**
	This determines if the given event can trigger a transition to a new state for currentState.
	Note that it does not actually perform the transition and save it to currentState
	
	- parameter event: the Event to trigger a transition
	
	- returns: the State we can transition to for the given Event
	*/
	public subscript(event: Event) -> State? {
		if let transitions = states[currentState] {
			if let nextState = transitions[event] {
				return nextState
			}
		}
		return nil
	}
	
	/**
	This attempts to transition from the currentState to the next state
	
	- parameter event: the Event used to look up the destination State for currentState
	
	- returns: the new state saved to currentState, if the lookup was successful
	*/
	public func transition(event: Event) -> State? {
		if let nextState = self[event] {
			currentState = nextState
			return nextState
		}
		return nil
	}
}
