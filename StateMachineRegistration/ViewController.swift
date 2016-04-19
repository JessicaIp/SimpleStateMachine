//
//  ViewController.swift
//  StateMachineRegistration
//
//  Created by Jessica Ip on 2016-04-15.
//  Copyright © 2016 theScore. All rights reserved.
//

import UIKit

// State machine states and events
enum RegistrationStates {
	case Login
	case CreateProfile
	case FacebookProfile
	case SelectAvatar
	case TermsAndConditions
	case Finished
}

enum RegistrationActions {
	case Login
	case Next
	case Back
	case RegisterLater
	case FacebookRegister
}

// User Action Protocol
protocol RegistrationActionProtocol {
	func notifyStateMachine(source: UIViewController, _ event: RegistrationActions)
}


// Main View Controller
class ViewController: UIViewController {

	// The first view controller our Main.storyboard loads is Login
	var registrationStateMachine = SimpleStateMachine<RegistrationStates, RegistrationActions>(initialState: .Login)
	
	// Reference all the screens in our master ViewController
	lazy var createProfileViewController: CreateProfileViewController = UIStoryboard(name: "Main", bundle: NSBundle(forClass: ViewController.self)).instantiateViewControllerWithIdentifier("CreateProfileViewController") as! CreateProfileViewController
	lazy var facebookProfileViewController: FacebookProfileViewController = UIStoryboard(name: "Main", bundle: NSBundle(forClass: ViewController.self)).instantiateViewControllerWithIdentifier("FacebookProfileViewController") as! FacebookProfileViewController
	lazy var selectAvatarViewController: SelectAvatarViewController = UIStoryboard(name: "Main", bundle: NSBundle(forClass: ViewController.self)).instantiateViewControllerWithIdentifier("SelectAvatarViewController") as! SelectAvatarViewController
	lazy var termsAndConditionsViewController: TermsAndConditionsViewController = UIStoryboard(name: "Main", bundle: NSBundle(forClass: ViewController.self)).instantiateViewControllerWithIdentifier("TermsAndConditionsViewController") as! TermsAndConditionsViewController

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register our transitions
		registrationStateMachine[.Login] = [
			.Next : .CreateProfile,
			.Login : .Finished
		]
		
		registrationStateMachine[.CreateProfile] = [
			.Next : .SelectAvatar,
			.FacebookRegister : .FacebookProfile,
			.RegisterLater : .TermsAndConditions
		]
		
		registrationStateMachine[.FacebookProfile] = [
			.Next : .SelectAvatar,
			.RegisterLater : .TermsAndConditions
		]
		
		registrationStateMachine[.SelectAvatar] = [
			.Next : .TermsAndConditions,
			.Back : .CreateProfile
		]
		
		registrationStateMachine[.TermsAndConditions] = [
			.Next : .Finished
		]

		setup()
	}
	
	func setup() {
		// Hide the navigation bar on the Login screen
		self.navigationController?.navigationBarHidden = true
		
		// Assign delegates
		createProfileViewController.delegate = self
		facebookProfileViewController.delegate = self
		selectAvatarViewController.delegate = self
		termsAndConditionsViewController.delegate = self
	}
}

// This is where the magic happens!
extension ViewController: RegistrationActionProtocol {
	func notifyStateMachine(source: UIViewController, _ event: RegistrationActions) {
		
		if let nextState = registrationStateMachine.transition(event) {
			
			if event == .Back { return } // UIKit handles popping of view controllers automatically when "back" is tapped
			
			self.navigationController?.navigationBarHidden = false
			
			// Handle the states we care about
			switch nextState {
			case .CreateProfile:
				self.navigationController?.pushViewController(createProfileViewController, animated: true)
			case .FacebookProfile:
				self.navigationController?.pushViewController(facebookProfileViewController, animated: true)
			case .SelectAvatar:
				// We never want to be able to go back to Facebook Profile, so we dismiss it before pushing the next VC
				if source == facebookProfileViewController {
					self.navigationController?.popViewControllerAnimated(false)
				}
				self.navigationController?.pushViewController(selectAvatarViewController, animated: true)
			case .TermsAndConditions:
				self.navigationController?.pushViewController(termsAndConditionsViewController, animated: true)
			case .Finished:
				print("Logged in!")
			default:
				return
			}
		}
	}
}


// Button Responders for the Login Screen
extension ViewController {
	
	@IBAction func didTapLogin(sender: AnyObject) {
		notifyStateMachine(self, .Login)
	}
	
	@IBAction func didTapRegister(sender: AnyObject) {
		notifyStateMachine(self, .Next)
	}
}

