//
//  ViewController.swift
//  Pquotes
//
//  Created by Yaseen Dar on 29/03/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit
import Floaty

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    let data = authors
    var author:String = ""
    var filteredData: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        filteredData = data
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting up Floating action button...
        let image = UIImage(named: "favourite.png") as UIImage?
        
        let floaty = Floaty()
        floaty.buttonImage  = image
        floaty.buttonColor = UIColor(white: 1, alpha: 0)
       
        floaty.addItem("View favourites", icon:image, handler: { item in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
            self.present(nextViewController, animated: true, completion: nil)
        })
        
        self.view.addSubview(floaty)
        
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
    
    

