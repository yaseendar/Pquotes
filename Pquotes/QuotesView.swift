//
//  Quotes.swift
//  Pquotes
//
//  Created by Yaseen Majeed on 07/04/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class QuotesView: UIViewController {
    @IBOutlet weak var quotesWebView: UIWebView!
    var quoteText:[String] = []
    var htmlContent:String = ""
//    convenience init(quotes:[String]){
//        self.init()
//        self.quoteText = quotes
//        self.htmlContent = createHtmlContent(quotes)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside the author VC and text is \(htmlContent)")
        quotesWebView.loadHTMLString(htmlContent, baseURL: nil)
        quotesWebView.allowsLinkPreview = true
        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex : "#00c4cc")
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createHtmlContent(_ quotesArray: [String]) -> String{
        var html:String = ""
        for i in quotesArray{
            html.append("<p><b>\(i)</b></p><br>")
        }
        return html
    }
}
