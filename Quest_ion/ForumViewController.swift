//
//  ChatViewController.swift
//  Quest_ion
//
//  Created by Tamir on 19/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class ForumViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var tblList: UITableView!
    private var  dataResult:[[String:Any]]!
	let backendless = Backendless.sharedInstance()!
    let singy = RecycleClass.getPointer()
    //An object that controll refresh animation
    var refreshControll:UIRefreshControl = UIRefreshControl()
	
	
	override func viewDidLoad(){
		super.viewDidLoad()
        singy.progressBarConfig(progressBar: progressBar)
        getDataBackendless()
       // tblList.backgroundColor = .clear
		singy.gradiant(view: self, array: singy.inAppArray())
        refreshConfiguration()
	}

    //Customize the refresh animation
    private func refreshConfiguration(){
        refreshControll.attributedTitle = NSAttributedString(string: "Refreshing", attributes: [NSAttributedStringKey.foregroundColor : UIColor.blue])
        refreshControll.tintColor = .blue
        refreshControll.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
        tblList.addSubview(refreshControll)
    }
    //Refresh all views data in the tableView.
    @objc func refreshTableView(){
        if refreshControll.isRefreshing {
            getDataBackendless()
            refreshControll.endRefreshing()
        }
    }
    
    
    
	//Set table row by data from backendless.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dataResult != nil){
        return dataResult.count
        }else {
            return 0
        }
    }
	
    //Configure table cell views.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblList.dequeueReusableCell(withIdentifier: "ForumTableView") as! CostumCell
        if dataResult != nil {
        cell.getData( result: dataResult, index: indexPath.row )
        }
		cell.backgroundColor = .white
        return cell
    }
	
	// Move to SendquestionViewController.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let move = storyboard!.instantiateViewController(withIdentifier: "answerQuestion") as! sendQuestionViewController
         move.getObjId(objId: dataResult[indexPath.row])
        present(move, animated: true, completion: nil)
    }
    
    //Recive information from backendless table "questions".
    func getDataBackendless(){
        backendless.data.ofTable("questions").find({(res)in
            //run on UI Main thread
            self.progressBar.isHidden = true
            self.dataResult = res as! [[String:Any]]
            self.tblList.reloadData()
            self.tblList.isHidden = false
        }, error: {(e)in
            print(e);
        })
        
    }

}


