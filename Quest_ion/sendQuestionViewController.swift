//
//  sendQuestionViewController.swift
//  Quest_ion
//
//  Created by Tamir on 23/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class sendQuestionViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var sendQuestionProgressBar: UIActivityIndicatorView!
    @IBOutlet weak var answerToQuestion: UITextView!
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var userQuestionText: UITextView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var userNameBtn: UIButton!
    let singy = RecycleClass.getPointer()
    var stringArray:[Substring] = [""]
	var  result:[String:Any]!;
    let backendless = Backendless.sharedInstance()
    var objId = "";
    

    override func viewDidAppear(_ animated: Bool) {
        if result != nil {
            setQuestionPage()
        }
    }
    
    override func viewDidLoad(){
        backBtn.layer.borderColor = UIColor.black.cgColor
        backBtn.layer.borderWidth = 0.5
        sendBtn.layer.borderColor = UIColor.black.cgColor
        sendBtn.layer.borderWidth = 0.5
        singy.gradiant(view: self, array: singy.inAppArray())
		questionsTableView.backgroundColor = .clear
        answerToQuestion.layer.borderWidth = 1
        answerToQuestion.layer.borderColor = UIColor.black.cgColor
    }
    
    //Configure the page views.
    private func setQuestionPage(){
        titleTxt.text = (result["Title"] as! String)
        singy.decodeUrlToImage(url:result["images"] as! String, imgV: questionImage, sendQuestionProgressBar)
        userQuestionText.text! =  result["question"] as! String
        if(result["answers"] != nil){
        toArrayString(text: result["answers"] as! String)
        }
		findUserDetails()
        questionsTableView.reloadData()
    }
    
    //Update owner of the question and question itself score column.
    @IBAction func sendRating(_ sender: UIButton) {
        sender.flash()
        let num1 = (result["Likes"] as! Int)
        let num2 = ((ratingValue.text! as NSString).integerValue)
        result["Likes"] = num1 + num2
        let dataStore = backendless?.data.ofTable("questions")
        dataStore?.save(result,  response: {(result) in print("update succeded")
            sender.isHidden = true
        }, error: {(failed) in print(failed as Any)})
        updateOwnerTbl()
    }
    
    //Update owner of the question.
    func updateOwnerTbl(){
        let dataStor = backendless?.data.ofTable("Users")
        let whereIs = "ownerId = '\(result["ownerId"]!)'"
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setWhereClause(whereIs)
        dataStor?.find(queryBuilder, response: {(result) in
            var userDetails: [String:Any] = (result as! [[String:Any]])[0]
            let num1 = userDetails["UserRating"] as! Int
            let num2 = ((self.ratingValue.text! as NSString).integerValue)
            userDetails["UserRating"] = num1 + num2
            dataStor?.save(userDetails)
        }, error: {(fault) in print(fault!)})
    }
    
    //Move to userSeenDataViewConroller
    @IBAction func openUserProfile(_ sender: UIButton) {
        let profileScreen:userSeenDataViewController = storyboard!.instantiateViewController(withIdentifier: "userSeenData") as! userSeenDataViewController
        profileScreen.getObjId(objId: result["ownerId"] as! String)
        show(profileScreen, sender: sender )
    }
    
    //Return to ForumViewController.
    @IBAction func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //Add answer coulomn "answers" in table "questions".
    @IBAction func sendQuestion(){
        if result["answers"] != nil{
        result["answers"] = "\(result["answers"]!)\(answerToQuestion.text!)~"
        }else {result["answers"] = "\(answerToQuestion.text!)~"}
        let dataStore = backendless!.data.ofTable("questions")
        dataStore?.save(result, response: {(result) in print("upload answer succded")
            self.dismiss(animated: true, completion: nil)
        }, error: {(fault) in self.singy.makeDialog(title: "upload answer  failed", dialogMsg: (fault?.message)!, btnMsg: "try again", screen: self)})
    }
    
    //Convert string to arrays of string.
    func toArrayString(text : String){
        stringArray = text.split(separator: "~")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringArray.count //return the number of question from backendless
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(stringArray[indexPath.row])
        cell.backgroundColor = .clear
        changeSize(cell: cell)
        changeRowColor(cell: cell, index: indexPath)
        return cell
    }
    //Every second cell will be in different color from the first.
    private func changeRowColor(cell:UITableViewCell , index:IndexPath){
        if(index.row%2 == 0){cell.textLabel?.textColor = .black}
        else{cell.textLabel?.textColor = UIColor.blue}
    }
    
    //Change the size of the answer by its length.
    private func changeSize(cell:UITableViewCell){
        let nsCell = cell.textLabel!.text! as NSString
        let x = nsCell.length
        if (x > 99 && x < 500 ){
            print("100 - 500")
            questionsTableView.rowHeight = 250
            cell.textLabel?.numberOfLines = 0;
            print(x)
        }else if(x > 499 && x < 1001) {
            questionsTableView.rowHeight = 450
            cell.textLabel?.numberOfLines = 0;
            print(x)
        }else{questionsTableView.rowHeight = 80
            cell.textLabel?.numberOfLines = 0
        }
       
}
    //Get result by index row.
	func getObjId(objId:[String:Any]){
        self.result = objId
    }
	
    //Change label text by the slider value.
    @IBAction func chageValue(_ sender: UISlider) {
        ratingValue.text = "\(Int(sender.value))"
    }
	
    //Show the owner of the question details.
	func findUserDetails(){
		let dataStore = backendless?.data.ofTable("Users")
		let whereIs = "ownerId = '\(result["ownerId"]!)'"
		print(whereIs)
		let queryBuilder = DataQueryBuilder()
        queryBuilder?.setWhereClause(whereIs)
		dataStore?.find(queryBuilder, response: {(result) in
			if(!(result!.isEmpty)){
			let details = (result as! [[String:Any]])
				let userDetails = details[0]
				self.userNameBtn.setTitle( "\(userDetails["NickName"]!) ", for: UIControlState.normal)
                self.userNameBtn.titleLabel?.text = userDetails["NickName"]!  as? String
            }}, error: {(fault) in print(fault as Any)})
			
	}
    
}
