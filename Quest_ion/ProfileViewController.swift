//
//  ProfileViewController.swift
//  Quest_ion
//
//  Created by Tamir on 19/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	
    @IBOutlet weak var profileProgressBar: UIActivityIndicatorView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var questionAsked: UILabel!
	@IBOutlet weak var rateScore: UILabel!
	@IBOutlet weak var textFieldName: UITextField!
	@IBOutlet weak var setUpBtn: UIButton!
	@IBOutlet weak var applyChangesBtn: UIButton!
	@IBOutlet weak var changeImageBtn: UIButton!
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var userName: UILabel!
	var imageData:Data!
	let currentUser:BackendlessUser = Backendless.sharedInstance().userService.currentUser
	let backendless = Backendless.sharedInstance()
    let singy = RecycleClass.getPointer()
	let imagePicker = UIImagePickerController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		singy.gradiant(view: self, array: singy.inAppArray())
		setInfoProfile()
		applyChangesBtn.isHidden = true
		changeImageBtn.isHidden = true
        cancelBtn.isHidden = true
        textFieldName.isUserInteractionEnabled = false
        textFieldName.borderStyle = .none
	}
    
    //Cancel setup profile method(visible only when pressed changeProfileDetails).
    @IBAction func Cancel(_ sender: Any) {
        textFieldName.isUserInteractionEnabled = false
        textFieldName.borderStyle = .none
        textFieldName.backgroundColor = .clear
        applyChangesBtn.isHidden = true
        setUpBtn.isHidden = false
        cancelBtn.isHidden = true
        changeImageBtn.isHidden=true
    }
    
    //User choose image from gallery.
	@IBAction func changeImage(_ sender: UIButton) {
		imagePicker.delegate = self
		imagePicker.sourceType = .photoLibrary
		show(imagePicker, sender: self)
	}
	
	
	
	// Logout the user and go to LoginViewController.
    @IBAction func logOut(_ sender: UIButton) {
        backendless?.userService.logout({(result) in print("user logout Successfully"); self.dismiss(animated: true, completion: nil)},
            error: {(fault) in print("logout: \(String(describing: fault))" )
             self.singy.move(screen: self, identifier: "Quest_ion")})
	}
	
    //Confirm the user changes and prepere the details to upload .
	@IBAction func applyChanges(_ sender: UIButton){
		applyChangesBtn.isHidden = true
		setUpBtn.isHidden = false
		changeImageBtn.isHidden = true
        cancelBtn.isHidden = true
        textFieldName.isUserInteractionEnabled = false
        textFieldName.backgroundColor = .clear
        textFieldName.borderStyle = .none
        let name = "\(currentUser.name.trimmingWhitespace()! as String).png"
		if imageData == nil {
			imageData = UIImagePNGRepresentation(profileImage.image!)
		}
		saveData(fileNamePath: "Profile//", name: name, imageData: imageData, overwriteIfExits: true)
		}
   
    //Save the data in backendless table "users".
	func saveData(fileNamePath:String,name:String,imageData:Data,overwriteIfExits:Bool){
		backendless!.file.saveFile(fileNamePath, fileName: name, content: imageData, overwriteIfExist: true)
		if (textFieldName.hasText){
            let SOURCE_URL = "https://api.backendless.com/A58EDBAA-8878-E1EF-FF45-B4459E5B6A00/8B531FBA-C5D8-1696-FF21-1DDB62C08D00/files/Profile/"
			let data = ["NickName":"\(textFieldName.text!)","ImageUser":"\(SOURCE_URL)\(name)"] as [String : Any];
			currentUser.updateProperties(data)
            backendless?.userService.update(currentUser, response: {(result) in print ("Update profile was successful")}, error: {(fault) in print(fault?.message! as Any)})
            singy.replaceImageUrl(url: "\(SOURCE_URL)\(name)",image: profileImage.image!)
			setInfoProfile()
		}else {
			singy.makeDialog(title: "Invalid inputs", dialogMsg: "pls enter user NickName", btnMsg: "Got it", screen: self)
		}
	}
	
    //Allow the user to set up his profile.
	@IBAction func changeProfileDetails(_ sender: UIButton) {
        textFieldName.borderStyle = .roundedRect
		applyChangesBtn.isHidden = false
		setUpBtn.isHidden = true
		changeImageBtn.isHidden = false
		textFieldName.isHidden = false
        cancelBtn.isHidden = false
        textFieldName.backgroundColor = .white
        textFieldName.isUserInteractionEnabled = true}
	
	
	//Configure the screen views.
	func setInfoProfile(){
		userName.text = "Welcom : \(currentUser.name! as String)"
	textFieldName.text = currentUser.getProperty("NickName") as? String
        questionAsked.text = "\(currentUser.getProperty("numberOfQuestions") as! Int)"
        rateScore.text = "\(currentUser.getProperty("UserRating") as! Int)"
        let image = currentUser.getProperty("ImageUser") as! String
        singy.decodeUrlToImage(url: image, imgV: profileImage, profileProgressBar)
        cancelBtn.isHidden = true
    }
	
    //When user picked image.
	func imagePickerController(_ p: UIImagePickerController, didFinishPickingMediaWithInfo d: [String : Any]) {
		let image = d[UIImagePickerControllerOriginalImage] as! UIImage
		profileImage.image = image 
		imageData = UIImagePNGRepresentation(image)
		dismiss(animated: true, completion: nil)
	}
	
    //Cancel the image pick action.
	func imagePickerControllerDidCancel(_ p: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
		print("Sorry but user didn't pick an image")
	}
	
	
	

  
}
