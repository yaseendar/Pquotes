//
//  ViewController.swift
//  Pquotes
//
//  Created by Yaseen Dar on 29/03/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit
import Floaty

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    let data = authors
    var author:String = ""
    var filteredData: [String]!
    let defaults = UserDefaults.standard
    static var fromNotification:Bool = false
    static var authorFromNotification:String = String()
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(ViewController.fromNotification){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
            nextViewController.selectedValue = ViewController.authorFromNotification
            self.present(nextViewController, animated: true,completion: nil)
            
       }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        filteredData = data
       
        
        
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
    

    override func viewWillAppear(_ animated: Bool) {
        
        //For syncing the text color of table cells...
        if defaults.bool(forKey: "DarkTheme"){
            Theme.darkTheme(view: self.view)
            headerView.backgroundColor = #colorLiteral(red: 0.4338841803, green: 0.4358325171, blue: 0.4100748698, alpha: 1)
        }
        else{
            Theme.defaultTheme(view: self.view)
            headerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
        }
        
        tableView.reloadData()
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewcell", for: indexPath) as!ControllerViewCell
        CommentsViewController.getQuotesFromJson()
        let quote = CommentsViewController.quotesData![filteredData[indexPath.row]] as? [Any]
        let quotesCount = quote!.count
       
        cell.authorLabel?.text = filteredData[indexPath.row]
        cell.quoteCountLabel?.text = String(quotesCount)
//        if(defaults.bool(forKey: "DarkTheme")){
//            cell.textLabel?.textColor = UIColor.white
//        }
//        else{
//            cell.textLabel?.textColor = UIColor.black
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
   
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let author = data[indexPath.row]
      //  print (author)
        //self.author = author

   //     self.performSegue(withIdentifier: "CommentsViewController", sender: self)
        
    }
    
    // Called when search bar obtains focus.  I.e., user taps
    // on the search bar to enter text.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        filteredData = data
      tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        
        if let destination = segue.destination as? CommentsViewController {
    
            let cell = sender as! UITableViewCell
            let selectedRow = tableView.indexPath(for: cell)!.row
            destination.selectedValue = filteredData[selectedRow]
        }
    }
    
}
    
    

