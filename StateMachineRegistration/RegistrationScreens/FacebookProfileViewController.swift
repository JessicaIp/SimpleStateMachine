//
//  FacebookProfileViewController.swift
//  StateMachineRegistration
//
//  Created by Jessica Ip on 2016-04-18.
//  Copyright © 2016 theScore. All rights reserved.
//

import UIKit

class FacebookProfileViewController: UIViewController {
	
	var delegate: RegistrationActionProtocol?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Facebook Profile"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Done, target: self, action: "didTapNextButton:")
		self.navigationItem.setHidesBackButton(true, animated: false)
	}
	
	// Tracks when back button is pushed
	override func didMoveToParentViewController(parent: UIViewController?) {
		super.didMoveToParentViewController(parent)		
		
		if parent == nil {
			delegate?.notifyStateMachine(self, .Back)
		}
	}
	
	func didTapNextButton(sender: AnyObject?) {
		delegate?.notifyStateMachine(self, .Next)
	}
	
	@IBAction func didTapSkipButton(sender: AnyObject) {
		delegate?.notifyStateMachine(self, .RegisterLater)
	}
}
