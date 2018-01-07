//
//  Button.swift
//  Quest_ion
//
//  Created by shim on 06/01/2018.
//  Copyright © 2018 Test. All rights reserved.
//
import UIKit
import Foundation
extension UIButton {
    //Animation
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
}





