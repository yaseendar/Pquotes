//
//  ViewController.swift
//  Pquotes
//
//  Created by Yaseen Dar on 29/03/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var headerQuotesLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    let data = authors
    var author:String = ""
    static var filteredData: [String]!
    let defaults = UserDefaults.standard
    static var fromNotification:Bool = false
    static var authorFromNotification:String = String()
    static var scrollPosition : IndexPath?
    static var fromSearch:Bool = false
    
    
    var quotesArrayWithAuthors :[String]?
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if(ViewController.fromNotification){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
            nextViewController.selectedValue = ViewController.authorFromNotification
            self.present(nextViewController, animated: true,completion: nil)
            
       }
    }
    
//    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//        Crashlytics.sharedInstance().crash()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase Analytics stuff here...
        Analytics.logEvent("App Opened", parameters: nil)
        
        //Crashlytics stuff here...
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//        button.setTitle("Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(button)
//
    
        quotesArrayWithAuthors = [String]()
        CommentsViewController.getQuotesFromJson()
        var fullData = CommentsViewController.quotesData
        let auths = (fullData! as NSDictionary).allKeys
        for key in auths{
            var quotes = fullData![key as! String] as! [String]
            var i = 0
            while (i < quotes.count){
                quotes[i].append("~\(key as! String)")
                quotesArrayWithAuthors?.append(quotes[i])

                i += 1
            }
          
        }
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        
        if ViewController.filteredData == nil{
            setFilteredData()
        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        //Do any additional setup after loading the view, typically from a nib.
        
        //Setting up Floating action button...
     /*   let image = UIImage(named: "favourite.png") as UIImage?
        
        let floaty = Floaty()
        floaty.buttonImage  = image
        floaty.buttonColor = UIColor(white: 1, alpha: 0)
       
        floaty.addItem("View favourites", icon:image, handler: { item in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
            self.present(nextViewController, animated: true, completion: nil)
        })
        
        self.view.addSubview(floaty)*/
        
    }
    
    
    func setFilteredData(){
        if defaults.bool(forKey: "quotesSwitch"){
            ViewController.filteredData = quotesArrayWithAuthors
        }
        else{
            ViewController.filteredData = data
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        if ViewController.fromSearch{
            searchBar.becomeFirstResponder()
        }
        else{
            searchBar.text = ""
        }

        //presenting list of authors/quotes based on the quotes switch value in settings...
        if defaults.bool(forKey: "quotesSwitch"){
            headerLabel.text = "Quotes"
            headerQuotesLabel.isHidden = true
        }
        else{
            headerLabel.text = "Authors"
            headerQuotesLabel.isHidden = false
        }
        
        if(ViewController.filteredData == nil){
            setFilteredData()
        }
        
        
        if let scroll = ViewController.scrollPosition{
        tableView.scrollToRow(at:scroll, at: UITableViewScrollPosition.top, animated: true)
        }
        
        //For syncing the text color of table cells...
        if defaults.bool(forKey: "DarkTheme"){
            Theme.darkTheme(view: self.view)
            headerView.backgroundColor = #colorLiteral(red: 0.4338841803, green: 0.4358325171, blue: 0.4100748698, alpha: 1)
            view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            tableView.backgroundColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        else{
            Theme.defaultTheme(view: self.view)
            headerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        tableView.reloadData()
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        if defaults.bool(forKey: "quotesSwitch"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "viewcell2", for: indexPath) as!View2TableViewCell
            let row = ViewController.filteredData[indexPath.row]
            let elements = row.components(separatedBy: "~")
            cell.quotesLabel.text = elements[0]
            cell.authorLabel.text = elements[1]
            
            //For syncing the text color of table cells...
            if defaults.bool(forKey: "DarkTheme"){
                cell.contentCell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
            else{
                cell.contentCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            return cell
        }
        else{
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewcell", for: indexPath) as!ControllerViewCell
        CommentsViewController.getQuotesFromJson()
            let quote = CommentsViewController.quotesData![ViewController.filteredData[indexPath.row]] as? [Any]
        
        if let quotesCount = quote?.count{
            cell.quoteCountLabel?.text = String(quotesCount)
        }
       
            cell.authorLabel?.text = ViewController.filteredData[indexPath.row]
            
        
            var author = ViewController.filteredData[indexPath.row]
        author = author.replacingOccurrences(of: " ", with: "_")
      
            //For syncing the text color of table cells...
            if defaults.bool(forKey: "DarkTheme"){
                cell.contentCell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
            else{
                cell.contentCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.filteredData.count
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ViewController.fromSearch = true
        
        if defaults.bool(forKey: "quotesSwitch"){
            ViewController.filteredData = searchText.isEmpty ? quotesArrayWithAuthors : quotesArrayWithAuthors?.filter { (item: String) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        else{
            ViewController.filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
       
        
        tableView.reloadData()
    }
   
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ViewController.scrollPosition = indexPath
    }
    
    // Called when search bar obtains focus.  I.e., user taps
    // on the search bar to enter text.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Analytics.logEvent("search_cancelled", parameters: nil)

        searchBar.text = nil
        searchBar.showsCancelButton = false
        ViewController.fromSearch = false
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        setFilteredData()
        
      tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if let destination = segue.destination as? CommentsViewController {
    
            let cell = sender as! UITableViewCell
            let selectedRow = tableView.indexPath(for: cell)!.row
            
           
            
            if(defaults.bool(forKey: "quotesSwitch")){
                destination.selectedValue = ViewController.filteredData[selectedRow].components(separatedBy: "~")[0]
                
                 destination.author = ViewController.filteredData[selectedRow].components(separatedBy: "~")[1]
                destination.fromQuotes = true
            }
            else{
                destination.selectedValue = ViewController.filteredData[selectedRow]
                destination.author = ViewController.filteredData[selectedRow]

            }
        }
    }
    
}
    
    

