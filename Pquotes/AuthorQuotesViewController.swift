//
//  AuthorQuotesViewController.swift
//  Pquotes
//
//  Created by Yaseen Dar on 02/04/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit

class AuthorQuotesViewController: UIViewController {
    @IBOutlet weak var quotes: UIWebView!
    var quoteText:[String] = []
    var htmlContent:String = ""
   convenience init(quotes:[String]){
        self.init()
        self.quoteText = quotes
        self.htmlContent = createHtmlContent(quotes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside the author VC and text is \(htmlContent)")
        quotes.loadHTMLString(htmlContent, baseURL: nil)
        quotes.allowsLinkPreview = true
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
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

    func createHtmlContent(_ quotesArray: [String]) -> String{
        var html:String = ""
        for i in quotesArray{
            html.append("<p>\(i)</p><br>")
        }
        return html
    }
}
