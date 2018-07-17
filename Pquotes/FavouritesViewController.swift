//
//  FavouritesViewController.swift
//  Pquotes
//
//  Created by Abdul Basit on 12/07/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {


    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Declarations.....
    @IBOutlet weak var backButton: UIBarButtonItem!
    let defaults = UserDefaults.standard
    var quotesArray:[String] = []
    var authorsArray:[String] = []
    
    
    
  /*  func setUpNavBar(){
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //edgesForExtendedLayout = []
        // setUpNavBar()
        
        
        
        
        
        //Getting string array from the userdefault......
         quotesArray = self.defaults.stringArray(forKey: "SavedQuotesArray") ?? [String]()
         authorsArray = self.defaults.stringArray(forKey: "SavedAuthorsArray") ?? [String]()
        
       //print(quotesArray)

        // Do any additional setup after loading the view.
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  quotesArray.count
    }
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouritesCell", for: indexPath) as!FavouriteQuotesTableViewCell
      
        
        cell.quotesTextView.text = "\" \(quotesArray[indexPath.row]) \""
        cell.authorLabel.text  = "~" + authorsArray[indexPath.row]
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.6
        
        return cell
    }

 //For deleting an item in the list....
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if(editingStyle == UITableViewCellEditingStyle.delete){
            //deleting item in arrays....
            quotesArray.remove(at: indexPath.row)
            authorsArray.remove(at: indexPath.row)
            
            //updating userdefault arrays.....
            self.defaults.set(quotesArray,forKey: "SavedQuotesArray")
            self.defaults.set(authorsArray,forKey: "SavedAuthorsArray")
            
            tableView.reloadData()
        }
    }

    
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight  = 100
        tableView.rowHeight = UITableViewAutomaticDimension
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
