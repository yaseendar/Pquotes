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
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        filteredData = data
        quotesOfAuthor = loadData()
        self.navigationController?.isNavigationBarHidden = false
        print("hurray \(quotesOfAuthor)")
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
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
        let author = data[indexPath.row]
        let authorVC = AuthorQuotesViewController(quotes: quotesOfAuthor[author]!)
        self.navigationController?.pushViewController(authorVC, animated: false)
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

