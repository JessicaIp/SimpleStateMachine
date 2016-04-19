//
//  CreateProfileViewController.swift
//  StateMachineRegistration
//
//  Created by Jessica Ip on 2016-04-18.
//  Copyright © 2016 theScore. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {
	
	var delegate: RegistrationActionProtocol?

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.title = "Register"
		self.navigationItem.setHidesBackButton(true, animated: false)
	}
	
	@IBAction func didTapEmailRegister(sender: AnyObject) {
		delegate?.notifyStateMachine(self, .Next)
	}
	
	@IBAction func didTapFacebookRegister(sender: AnyObject) {
		delegate?.notifyStateMachine(self, .FacebookRegister)
	}
	
	@IBAction func didTapSkip(sender: AnyObject) {
		delegate?.notifyStateMachine(self, .RegisterLater)
	}
}
