//
//  RegisterViewController.swift
//  Quest_ion
//
//  Created by Tamir on 19/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
	@IBOutlet var registrationLbl: UILabel!
	@IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userName: UITextField!
	@IBOutlet weak var accountExustBtn: UIButton!
	@IBOutlet weak var registerMeBtn: UIButton!
	let singy = RecycleClass.getPointer()
    let backendless = Backendless.sharedInstance()
	
	override func viewWillAppear(_ animated: Bool) {
		registrationLbl.alpha = 0
		singy.fadeIn(view: registrationLbl)
		singy.animate(views: [registerMeBtn , accountExustBtn , userName , userPassword ])
	}
	
	override func viewDidLoad(){
		super.viewDidLoad()
		singy.gradiant(view: self , array: singy.blueColorsArray())
	}
   
    // Return to LoginViewController.
    @IBAction func userHaveAccount(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //Register User to backendless by name and password.
    @IBAction func registerUser(_ sender: UIButton) {
        let backUser = BackendlessUser()
        backUser.name = userName.text! as NSString
        backUser.password = userPassword.text! as NSString
        backendless?.userService.register(backUser, response: {(result)
            in print("user register successful ")
           self.singy.move(screen: self, identifier: "Quest_ion")
        },
            error: {(fault) in print(fault?.message as Any);
            self.singy.makeDialog(title: "Error", dialogMsg: (fault?.message)!, btnMsg: "Ok", screen: self)
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
