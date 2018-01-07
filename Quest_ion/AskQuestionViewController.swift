//
//  AskQuestionViewController.swift
//  Quest_ion
//
//  Created by Tamir on 19/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class AskQuestionViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var img :UIImageView!
    @IBOutlet weak var bodyQuestion: UITextView!
    @IBOutlet weak var titleQuestion: UITextField!
    @IBOutlet var askQuestionSection: UITextView!
	var currentUser:BackendlessUser!
    var imageData : Data!
    var name = " "
    let imagePicker = UIImagePickerController()
    let singy = RecycleClass.getPointer()
    let backendless = Backendless.sharedInstance()
	
	
	override func viewDidLoad(){
		singy.roundView(UIView: titleQuestion)
		setting()
        super.viewDidLoad()
		singy.gradiant(view: self, array: singy.inAppArray())
		currentUser = backendless?.userService.currentUser
		name = currentUser.name as String
		name = name.trimmingCharacters(in: .whitespaces)
        imagePicker.delegate = self
        imageData = UIImagePNGRepresentation(img.image!)
    }
	
    //Prepere question info to be saved in backendless .
	@IBAction func uploadData(_ sender: Any){
		let imageName = "image\(name)\(currentUser.getProperty("numberOfQuestions") as! Int).png" // save image name by user name , Question ask by the user number.
		let data = ["AskedBy":currentUser.getProperty("NickName") as! String,"question":"\(bodyQuestion.text!)","images":"https://api.backendless.com/A58EDBAA-8878-E1EF-FF45-B4459E5B6A00/8B531FBA-C5D8-1696-FF21-1DDB62C08D00/files/images%3A/+\(imageName)","Title":"\(String(describing: titleQuestion.text!))"] as [String : Any] // Set details that should be uploaded to backendless.
		updateQuestionTable(data: data,imageName:imageName )
	}
	
	private func setting(){
		askQuestionSection.backgroundColor = .white
		askQuestionSection.layer.borderWidth = 1
		askQuestionSection.layer.borderColor = UIColor.black.cgColor
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	//User pick image fromgallery.
    @IBAction func getImage( btn:UIButton){
        imagePicker.sourceType = .photoLibrary
        show(imagePicker, sender: self)
    }
	

    func imagePickerController(_ p: UIImagePickerController, didFinishPickingMediaWithInfo d: [String : Any]) {
    	let image = d[UIImagePickerControllerOriginalImage] as! UIImage
		img.image = image 
        imageData  = UIImagePNGRepresentation(image)!
		dismiss(animated: true, completion: nil)
    }
	
    func imagePickerControllerDidCancel(_ p: UIImagePickerController) {
        dismiss(animated: true, completion: nil);
        print("Sorry but user didn't pick an image")
    }
  
	
    
    //Save data in backendless table question.
    func updateQuestionTable(data:[String:Any],imageName:String){
        let dataStore = backendless?.data.ofTable("questions")
        dataStore?.save(data, response: {(result) in print ("Upload succeded\(result!)")
        self.updataUsersTable()
		self.uploadImage(imageName: imageName)
        self.singy.makeDialog(title: "Upload successfully", dialogMsg: "Refresh the forum to see your qeustion", btnMsg: "Great thx", screen: self)
        }, error: {(fault) in
        self.singy.makeDialog(title: "Oops something went wrong", dialogMsg: (fault?.message)!, btnMsg: "try again", screen: self)
        print("\((describing: fault))")})
    }
   
    //Upload question image to the backendless files "Images:".
	func uploadImage(imageName:String){
        self.backendless?.file.saveFile("images://", fileName:" \(imageName)", content: imageData,
            response: {
            (result) in print("Loding"); print("Upload successful")},
            error: {
			(fault) in print ("\(String(describing: fault)) error occoured upload image")
        })
        titleQuestion.text = ""
        bodyQuestion.text = ""
        img.image = #imageLiteral(resourceName: "NoImage")
    }
    
    // Update user coulumn questionAsked incremnt by 1.
    func updataUsersTable(){
        let userData = ["numberOfQuestions":currentUser.getProperty("numberOfQuestions" ) as! Int + 1]
        currentUser.updateProperties(userData)
        backendless?.userService.update(currentUser)
	}
}
