//
//  MovingScreensClass.swift
//  
//
//  Created by Tamir on 23/12/2017.
//

import Foundation
import UIKit
class MovingScreenClass {
    
    let singy = RecycleClass.getPointer()
    public  func moveScreens(string:String){
        let move = storyboard!.instantiateViewController(withIdentifier: string)
        present(move, animated: true, completion: nil)
    }
}
