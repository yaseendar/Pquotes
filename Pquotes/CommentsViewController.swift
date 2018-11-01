//
//  CommentsViewController.swift
//  Pquotes
//
//  Created by Abdul Basit on 10/07/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit
import SwiftyJSON


class CommentsViewController: UIViewController{
   
    @IBAction func authorImageClicked(_ sender: Any) {
        authorInfoButtonClicked(sender)
    }
    
    //Declarations here...
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var showingLabel: UILabel!
    
    
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var prevButton: UIBarButtonItem!
    
    static var quotesData: Dictionary<String,AnyObject>?
    
    let defaults = UserDefaults.standard
    
    var selectedValue:String = ""
    var quotes:[Any]?
    var author:String = String()
    var count:Int = 0
    var fromQuotes = false

    
    
    @IBAction func authorInfoButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        
        alert.popoverPresentationController?.sourceView = view // works for both iPhone & iPad
        
        

        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.90)
        alert.view.addConstraint(height);
        alert.view.frame.size.height = self.view.frame.height * 0.90
        
        let web = UIWebView(frame: CGRect(x: 10, y: 5, width: self.view.frame.size.width * 0.9 , height: self.view.frame.size.height * 0.8))
        
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
    
    
    @IBAction func nexButtonClicked(_ sender: Any) {
        // print("count: \(count)")
        print("quotes.count: \(quotes!.count)")
        if count < quotes!.count-1{
            count = count + 1
            commentLabel.fadeTransition(0.6)
            commentLabel.text = " \" \(quotes![count])\" "
        }
        if count  == quotes!.count-1{
            nextButton.isEnabled = false
        }
        
        if count == 1{
            prevButton.isEnabled = true
        }
        showingLabel.text = "Showing \(count+1) of \(quotes!.count)"
    }
    
    func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()
        
        let author = "   By: "+self.author
        
        if let textToShare = commentLabel.text {//Enter link to your app here
            let objectsToShare = [textToShare, author] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }

    @IBAction func shareButtonClicked(_ sender: Any) {
        share(sender: self.view)
    }
    
    @IBAction func addToFavouritesButtonClicked(_ sender: Any) {
        //Getting string array from the userdefault......
        var tempArray1 = self.defaults.stringArray(forKey: "SavedQuotesArray") ?? [String]()
        var tempArray2 = self.defaults.stringArray(forKey: "SavedAuthorsArray") ?? [String]()
        
        if !tempArray1.contains(self.quotes![self.count] as! String){
            
            
            
            
            //Appending the selected quotes to the saved favourite quotes array.........
            tempArray1.append(self.quotes![self.count] as! String)
            
            //Appending the selected authors to the saved favourite authors array.........
            tempArray2.append(self.author)
            
            
            //Saving the added results.........
            self.defaults.set(tempArray1,forKey: "SavedQuotesArray")
            self.defaults.set(tempArray2,forKey: "SavedAuthorsArray")
            
            //print(tempArray2)
            
        }
        else{
            print("quote already in favourites")
        }
        
        //Prompting user...........
        let alert = UIAlertController(title: "", message: "Added to favourites...", preferredStyle: .alert)
        
        //for dismissing alertview on background tap...
        self.present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }
        
        //for dismissing alert automatically after 2 seconds...
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func preButtonClicked(_ sender: Any) {
        nextButton.isEnabled = true
        if count > 0{
            count = count - 1
            commentLabel.fadeTransition(0.8)
            commentLabel.text = " \" \(quotes![count])\" "
        }
        if count == 0{
            prevButton.isEnabled = false
        }
        
        if count > quotes!.count-1{
            nextButton.isEnabled = true
        }
        showingLabel.text = "Showing \(count+1) of \(quotes!.count)"
    }

    override func viewWillAppear(_ animated: Bool) {
        if  UserDefaults.standard.bool(forKey: "quotesSwitch") == false && showingLabel.isHidden == false {
            showingLabel.isHidden = false
        }
        else{
            showingLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
         if let image = UIImage(named: "authors/"+author.replacingOccurrences(of: " ", with: "_")+".jpg"){
         authorImageView.image = image
            authorImageView.layer.cornerRadius = authorImageView.frame.width/2
            authorImageView.clipsToBounds = true
         }
         else{
         authorImageView.image = UIImage(named:"authors/if_Writer_Male_Light_80929.png")
         }
        
        
        ViewController.fromNotification = false
        
        commentLabel.text = selectedValue
        navigationTitleItem.title = author
        
        //Hiding prev and next buttons here...
        prevButton.isEnabled = false
        nextButton.isEnabled = false
        
        if defaults.bool(forKey: "DarkTheme"){
            Theme.darkTheme(view: self.view)
            self.view.backgroundColor = UIColor.darkGray
        }
        else{
            Theme.defaultTheme(view: self.view)
            self.view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 235/255, alpha: 1.0)
        }

      //--------------------------------------------------------------------------------------
       
       //Code for getting the quotes from the json file......
       if let path = Bundle.main.path(forResource: "comments", ofType: "json") {
           do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let commentString = jsonResult[selectedValue] as? [Any] {
                
                if(!fromQuotes){
                    quotes = commentString
                    
                    commentLabel.text = " \(commentString[0]) "
                    
                    showingLabel.text  = "Showing 1 of \(commentString.count)"
                    if(commentString.count == 1){
                        showingLabel.isHidden = true
                    }
                    
                    //Checking if there are more than one quote by an author....
                    if commentString.count>1{
                        nextButton.isEnabled = true
                    }
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
    
    
    //function for dismissing alertview on background tap....
    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
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
    
    static func getQuotesFromJson(){
        if let path = Bundle.main.path(forResource: "comments", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    quotesData = jsonResult
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }

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
