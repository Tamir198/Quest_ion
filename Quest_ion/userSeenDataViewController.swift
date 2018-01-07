//
//  userSeenDataViewController.swift
//  Quest_ion
//
//  Created by Tamir on 27/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class userSeenDataViewController: UIViewController {
    @IBOutlet weak var askerRating: UILabel!
    @IBOutlet weak var askerQuestionsAsked: UILabel!
    @IBOutlet weak var askerName: UILabel!
    @IBOutlet weak var askerImage: UIImageView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    let backendless = Backendless.sharedInstance()
    let singy = RecycleClass.getPointer()
    var objId = ""

    override func viewWillAppear(_ animated: Bool) {
        singy.progressBarConfig(progressBar: progressBar)
       let dataStore = backendless?.data.ofTable("Users")
        let whereIs = "ownerId = '\(objId)'"
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setWhereClause(whereIs)
        //Find owner question by "ownerId" and set up the views.
        dataStore?.find(queryBuilder, response: {(result) in
            let details = result as! [[String:Any]]
            let userDetails = details[0]
            self.askerName.text = userDetails["NickName"] as? String
            self.askerRating.text = " \((userDetails[ "UserRating"] as! Int))"
            self.singy.decodeUrlToImage(url: userDetails["ImageUser"] as! String, imgV: self.askerImage, self.progressBar)
            self.askerQuestionsAsked.text = "\( userDetails["numberOfQuestions"] as! Int)"
        }, error: {(fault) in print(fault!)})
    }
    
	override func viewDidLoad() {
		singy.gradiant(view: self, array: singy.inAppArray())
	}
    
    //Return to sendQuestionController.
    @IBAction func moveBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getObjId( objId:String) {
        self.objId = objId 
    }
    
}
