//
//  ViewController.swift
//  Quest_ion
//
//  Created by hackeru on 17/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var backendless = Backendless.sharedInstance() 
    let singy = RecycleClass.getPointer()
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var userName: UITextField!
	@IBOutlet weak var loginBtn: UIButton!
	@IBOutlet weak var registerBtn: UIButton!
	@IBOutlet weak var questionLbl: UILabel!
	
	override func viewWillAppear(_ animated: Bool) {
		stayLoggedIn()
		questionLbl.alpha = 0
		singy.fadeIn(view: questionLbl)
		singy.animate(views: [loginBtn , registerBtn , userPass , userName])
	}
    
	override func viewDidLoad(){
		super.viewDidLoad()
		singy.gradiant(view: self , array: singy.blueColorsArray())
	}
    
    //Go to registerViewController.
	@IBAction func register(_ sender: UIButton) {
        sender.flash()
        singy.move(screen: self, identifier: "registration")
    }
	
	// Login user to app if credentials are valid.
	@IBAction func Login(_ sender: UIButton) {
            sender.flash()
            backendless!.userService.login(userName.text, password: userPass.text, response: {(user) in
			print ("login successfull")
            self.singy.move(screen: self, identifier: "tabBarController")
            // Relogin the user if did not logout.
            self.backendless?.userService.setStayLoggedIn(true)
            }
            , error: {(fault) in
			print("\(fault!) error number")
            self.singy.makeDialog(title: "Login denied", dialogMsg: (fault!.message!), btnMsg: "cancel", screen: self)
            })
        }
    
    //Check if the user still logged in.
    func stayLoggedIn(){
        backendless?.userService.isValidUserToken({(result) in
            if(result?.boolValue)!{
                self.singy.move(screen: self, identifier: "tabBarController")           }
        }, error: {(fault)
            in print (fault as Any)})
        
    }
}

