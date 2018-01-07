//
//  CostumCell.swift
//  Quest_ion
//
//  Created by shim on 21/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import Foundation
import UIKit

public class CostumCell:UITableViewCell {
    @IBOutlet var imgProgressBar: UIActivityIndicatorView!
	public static var flyWieght:[String:UIImage] = [:] // FlyWieght design pattern
    let singy = RecycleClass.getPointer()
    
      // Get data from ForumViewController.
    func getData(result:[[String:Any]],index:Int){
        ShowData(title: result[index]["Title"] as! String, likes: result[index]["Likes"] as! Int,url:result[index]["images"]! as! String)
    }
    
    //Configures ForumViewController table views .
    func ShowData(title:String,likes:Int,url:String){
        label(byIdx: 1).text = "\(likes)"
        label(byIdx: 2).text = title
        singy.decodeUrlToImage(url: "\(url)", imgV: img(byIdx: 0), imgProgressBar)
        if img(byIdx: 0).image != nil{
            imgProgressBar.isHidden = true
        }
    }
	//Set title text.
    private func label(byIdx i: Int)-> UILabel{
        return contentView.subviews[i] as! UILabel
    }
    //Set img
    private func img(byIdx i: Int)-> UIImageView{
        return contentView.subviews[i] as! UIImageView;
    }
    
	}


    
    
    
    
    
    
    

