//
//  AboutUsViewController.swift
//  Quest_ion
//
//  Created by Tamir on 19/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
//Simple text show about the application.
class AboutUsViewController: UIViewController {
    @IBOutlet weak var aboutUsTxt: UITextView!
	let singy = RecycleClass.getPointer()
    
	override func viewDidLoad(){
        super.viewDidLoad()
		aboutUsTxt.backgroundColor = .clear
		singy.gradiant(view: self, array: singy.inAppArray())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
