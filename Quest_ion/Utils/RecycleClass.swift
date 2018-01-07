//
//  RecycleClass.swift
//  Quest_ion
//
//  Created by hackeru on 20/12/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import Foundation
import UIKit

 // Singleton class.
class RecycleClass{
    //Singy is the only instance of the class - singleton.
    private static let singy = RecycleClass()
    private init(){
	}
    
    public static func getPointer()->RecycleClass{
        return singy //return singleton object
    }
    
    // Change the screen by the identifier and the current viewController
    public  func move(screen:UIViewController , identifier:String){
        let move = screen.storyboard!.instantiateViewController(withIdentifier: identifier)
        screen.show(move, sender: nil)
    }
    
    // Decode the file from url address to UIImage and add it to flyWight dictionary if not exist.
    public func decodeUrlToImage(url:String, imgV: UIImageView , _ progressbar : UIActivityIndicatorView )  {
        //If image exist by url retrive it from flyWieght.
        if let fImg = CostumCell.flyWieght[url] {
            imgV.image = fImg
            progressbar.isHidden = true
            //Else decode the url to get the image and add it to flyWeight.
        }else{
            imgV.image = UIImage(named: "noImage")
            AsyncTask(backgroundTask: {(url: String) -> UIImage? in
                let urlGet = URL(string: url)!
                if  let data = try?Data(contentsOf: urlGet){
                    return UIImage(data: data)
                }
                return nil;
            }, afterTask: {(img)in
                if(img != nil) {
                    imgV.image = img
                    CostumCell.flyWieght[url] = img
                }
                progressbar.isHidden = true
            }).execute(url)
        }
	}
    
    func replaceImageUrl(url:String,image:UIImage){
        print("before")
        if  CostumCell.flyWieght[url] != nil{
            print("true")
            CostumCell.flyWieght[url] = image
    }
        print("false")
    }
    
    //Colors that will shown on screen.
   private let mediumBlue = UIColor(red: 0.1333, green: 0.5098, blue: 0.8392, alpha: 0.7).cgColor
   private let dodgerBlue = UIColor(red: 0.1451, green: 0.8275, blue: 0.9176, alpha: 1.0).cgColor
   private let cyan = UIColor(red: 0, green: 1, blue: 0.68, alpha: 1).cgColor
	//The app them colors.
	private let inApp1 = UIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 0.7).cgColor
	private let inApp2 = UIColor(red: 230/255, green: 255/255, blue: 240/255, alpha: 1.0).cgColor
	private let inApp3 = UIColor(red: 0, green: 1, blue: 0.68, alpha: 1).cgColor
    //Blue app them colors
     private let blue1 = UIColor(red: 26/255, green: 140/255, blue: 184/255, alpha: 0.7).cgColor
    private let blue2 = UIColor(red: 26/255, green: 156/255, blue: 184/255,alpha: 0.7).cgColor
    private let blue3 = UIColor(red: 26/255, green: 184/255, blue: 164/255, alpha: 0.7).cgColor
    
    //Wood gradient color
    private let color1 = UIColor(red: 234/255, green: 205/255, blue: 163/255, alpha: 1).cgColor
      private let color2 = UIColor(red: 214/255, green: 174/255, blue: 123/255, alpha: 1).cgColor
    
    
    
    //Put the collors together and make gradient.
	public  func gradiant(view:UIViewController , array:[CGColor] ){
        let l = CAGradientLayer();
		l.colors = array
        l.locations = [0.3, 0.7 , 1];
        let s =  view.view.bounds.size;
        l.frame = CGRect(
            origin: CGPoint(x: 1, y: 0),
            size: CGSize(width: s.width, height: s.height)
        );
       view.view.layer.insertSublayer(l, at: 0);
    }
	
	public func blueColorsArray() -> [CGColor]{
		let array = [mediumBlue,dodgerBlue,cyan]
		return array
	}
	
	public func inAppArray() -> [CGColor]{
        let array = [color1 , color2 ]//[inApp1,inApp2,inApp3]
		return array
	}
	//Fadein animation
	public func fadeIn(view:UIView){
		UIView.animate(withDuration: 0.5, delay: 0.5, options: .transitionFlipFromLeft   , animations: {
			view.alpha = 1
		}, completion: nil)
	}
    //Animation:
	public func animate(views:[UIView]){
		//Initializing button size using core graphics.
		for i in views{
		i.transform = CGAffineTransform(scaleX: 0.5, y: 0.1)
		//The animation that will return the views to their original size.
		UIView.animate(withDuration: 1,
			//Will start animate afer x second.
			delay: 0.2,
			//When the value will be close to 0 the view will achieve more bounciness.
			usingSpringWithDamping: 0.8,
			//How fast the animation will initialize.
			initialSpringVelocity: 1,
			//Allow the user to click the view while being drawn.
			options: .allowUserInteraction,
			animations: {
				//Rounding up the button.
				self.roundView(UIView: (i))
				i.layer.borderWidth = 1
				self.checkValueOf(i: i)
				/*Clips to bounds -> when true change imageView frame to the future drawn farme , when false change the new image frame is drawn on the old image frame
				this value is false by default.
				****** If this was not clear just change true to fals and see for yourself ****** */
				i.clipsToBounds = true
				//Returns view to original size.
				i.transform = .identity
		},     completion: nil )
	}
		}
	
	private func checkValueOf(i:UIView){
		if (i is UIButton){
			i.layer.borderColor = self.dodgerBlue
			i.backgroundColor = .blue
		}else if(i is UILabel){
			i.layer.borderColor = self.inApp3
			i.backgroundColor = .white
		}
		
		
	}
	func roundView(UIView: UIView){
		UIView.layer.cornerRadius = 0.5*UIView.bounds.height
	}
  
    //Pop up dialog.
	public func makeDialog(title : String, dialogMsg : String ,btnMsg : String, screen : UIViewController){
		//Add dialog with the title.
		let dialog = UIAlertController(title: title, message: dialogMsg, preferredStyle: .alert )
		screen.present(dialog, animated: true, completion: nil)
		//Add button to the alert.
		dialog.addAction(UIAlertAction(title: btnMsg , style: .cancel , handler: nil))
    }
    //Configuration for progress bar.
    func progressBarConfig(progressBar : UIActivityIndicatorView){
        progressBar.startAnimating()
        progressBar.color = .cyan
        progressBar.transform = CGAffineTransform(scaleX: 5, y: 5)
    }
    
    
	}


	
	

