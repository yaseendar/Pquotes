//
//  ViewController.swift
//  Pquotes
//
//  Created by Yaseen Dar on 29/03/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    let data = authors
    var quotesOfAuthor: [String:[String]] = [:]
    var filteredData: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        //self.automaticallyAdjustsScrollViewInsets = false
        self.title = "Quotes"
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        filteredData = data
        quotesOfAuthor = loadData()
        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex : "#00c4cc")
//        self.searchBar?.barTintColor = hexStringToUIColor(hex : "#00c4cc")
        print("hurray \(quotesOfAuthor)")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        searchBar.resignFirstResponder()
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lbl:String
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        if searchBar.isFirstResponder && searchBar.text != ""{
            lbl = filteredData[indexPath.row]
        }
        else{
            lbl = data[indexPath.row]
        }
        cell.textLabel?.text = lbl
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //searchBar.showsCancelButton = true
        filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        if searchText != ""{
            searchBar.showsCancelButton = true        }
        tableView.reloadData()
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        filteredData = data
        tableView.reloadData()
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let author : String
        if searchBar.isFirstResponder && searchBar.text != ""{
            author = filteredData[indexPath.row]
        }
        else{
            author = data[indexPath.row]
        }
       // let authorVC = QuotesView(quotes: quotesOfAuthor[author]!)
        let viewName = "quotesView"
        let destinationView = self.storyboard?.instantiateViewController(withIdentifier: viewName) as! QuotesView
        destinationView.htmlContent = destinationView.createHtmlContent(quotesOfAuthor[author]!)
        self.navigationController?.pushViewController(destinationView, animated: false)
//         self.navigationController?.present(destinationView, animated: false, completion: nil)
        print (author)
        
    }
    
    func loadData() -> [String:[String]]{
        var quotesDict:[String:[String]] = [:]
        guard let path = Bundle.main.path(forResource: "comments.json", ofType: nil) else {
            super.viewDidLoad()
            return ["":[""]]
        }
        do
        {
        let jsonData = try JSON(data:String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: String.Encoding.utf8)!)
            let dict = jsonData.dictionaryObject
            for (author,quotes) in dict!{
                quotesDict[author] = quotes as? [String]
                //print("The Author name is \(author as String) and quotes dic is \(quotes.array)")
            }
        }
        catch {
            print("Error loading JSON")
        }
       return quotesDict
    }
}


