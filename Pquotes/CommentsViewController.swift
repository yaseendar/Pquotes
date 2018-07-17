//
//  CommentsViewController.swift
//  Pquotes
//
//  Created by Abdul Basit on 10/07/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Floaty


class CommentsViewController: UIViewController{
    
    //Declarations here...
   
   
    
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
   
    
    let defaults = UserDefaults.standard
   
    
    var selectedValue:String = ""
    var quotes:[Any]?
    
    var count:Int = 0
    

    
    
    @IBAction func authorInfoButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        
        alert.popoverPresentationController?.sourceView = view // works for both iPhone & iPad
        
        

        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.90)
        alert.view.addConstraint(height);
        alert.view.frame.size.height = self.view.frame.height * 0.90
        
        let web = UIWebView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width * 0.9 , height: self.view.frame.size.height * 0.8))
        
        web.isOpaque = false;
        web.backgroundColor = UIColor.clear
        
        let scrollableSize = CGSize(width: view.frame.size.width, height: web.scrollView.contentSize.height)

        web.scrollView.contentSize = scrollableSize
         web.scalesPageToFit = true
        
        
        let tempName = selectedValue.replacingOccurrences(of: " ", with: "_")
        let URL = NSURL(string: "https://en.wikipedia.org/wiki/"+tempName)
        web.loadRequest(NSURLRequest(url: URL! as URL) as URLRequest)
        
        alert.view.addSubview(web)
        
      
        
        alert.addAction(UIAlertAction(title: "Got It", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
       
    }
    
  
    
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        // print("count: \(count)")
                print("quotes.count: \(quotes!.count)")
                if count < quotes!.count-1{
                    count = count + 1
                    commentLabel.fadeTransition(0.6)
                    commentLabel.text = " \" \(quotes![count])\" "
                }
                if count  == quotes!.count-1{
                    nextButton.isHidden = true
                }
        
                if count == 1{
                    prevButton.isHidden = false
                }
    }


    @IBAction func prevButtonClicked(_ sender: Any) {
       nextButton.isHidden = false
                    if count > 0{
                            count = count - 1
                            commentLabel.fadeTransition(0.8)
                            commentLabel.text = " \" \(quotes![count])\" "
                            }
                            if count == 0{
                            prevButton.isHidden = true
                            }
        
                           if count > quotes!.count-1{
                            nextButton.isHidden = false
                            }
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    
        commentLabel.text = selectedValue
       navigationTitleItem.title = selectedValue
        
        //Hiding prev and next buttons here...
        prevButton.isHidden = true
        nextButton.isHidden = true
        
        //Setting up Floating action button...
        let image = UIImage(named: "favourite.png") as UIImage?
        
        let floaty = Floaty()
        floaty.buttonImage  = image
        floaty.buttonColor = UIColor(white: 1, alpha: 0)

       
        floaty.addItem("Add to favourites", icon: image, handler: { item in
            
            //Getting string array from the userdefault......
            var tempArray1 = self.defaults.stringArray(forKey: "SavedQuotesArray") ?? [String]()
            var tempArray2 = self.defaults.stringArray(forKey: "SavedAuthorsArray") ?? [String]()
          
            if !tempArray1.contains(self.quotes![self.count] as! String){
                
                
            
            
            //Appending the selected quotes to the saved favourite quotes array.........
            tempArray1.append(self.quotes![self.count] as! String)
            
            //Appending the selected authors to the saved favourite authors array.........
            tempArray2.append(self.selectedValue)
            
            
            //Saving the added results.........
            self.defaults.set(tempArray1,forKey: "SavedQuotesArray")
            self.defaults.set(tempArray2,forKey: "SavedAuthorsArray")
            
            //print(tempArray2)
                
            }
            else{
                print("quote already in favourites")
            }
            
            //Prompting user...........
            let alert = UIAlertController(title: "Done!", message: "Added to favourites...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            floaty.close()
        })
        
        floaty.addItem("View favourites",icon: image, handler: { item in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
            self.present(nextViewController, animated: true, completion: nil)
        })
        
        self.view.addSubview(floaty)
        
        
        

      //--------------------------------------------------------------------------------------
       
       //Code for getting the quotes from the json file......
       if let path = Bundle.main.path(forResource: "comments", ofType: "json") {
           do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let commentString = jsonResult[selectedValue] as? [Any] {
                
                quotes = commentString
               

                
                commentLabel.text = " \" \(commentString[0])\" "
                
                //Checking if there are more than one quote by an author....
                if commentString.count>1{
                    nextButton.isHidden = false
                }
                
                
        }
           } catch let error {
               print("parse error: \(error.localizedDescription)")
            }
       } else {
            print("Invalid filename/path.")
        }
 //--------------------------------------------------------------------------------------
        
        

       
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}

    //Adding extension to UILabel for transition animation....
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}
