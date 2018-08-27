//
//  Theme.swift
//  Pquotes
//
//  Created by Abdul Basit on 16/08/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//
import Foundation
import UIKit

struct Theme {
    
    static var backgroundColor:UIColor?
    static var buttonTextColor:UIColor?
    static var buttonBackgroundColor:UIColor?
    static var labelColor:UIColor?
    static var navigationColor: UIColor?
    static var textViewColor: UIColor?
    static var view: UIView?
    static var viewColor: UIColor?
    static var tableViewCellColor: UIColor?
   
    static public func defaultTheme(view:UIView) {
        self.view = view
        self.backgroundColor = UIColor.white
        self.buttonTextColor = UIColor.blue
        self.buttonBackgroundColor = UIColor.white
        self.labelColor = UIColor.black
        self.navigationColor = UIColor.white
        self.textViewColor = UIColor.black
        self.viewColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.tableViewCellColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        updateDisplay()
    }
    
    static public func darkTheme(view: UIView) {
        self.view = view
        self.backgroundColor = UIColor.darkGray
        self.buttonTextColor = UIColor.white
        self.buttonBackgroundColor = UIColor.black
        self.labelColor = UIColor.white
        self.navigationColor = UIColor.lightGray
        self.textViewColor = UIColor.white
        self.viewColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.tableViewCellColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        updateDisplay()
    }
    
    static public func updateDisplay() {
     
      
        let textView = UITextView.appearance()
        textView.textColor = textViewColor
        textView.backgroundColor = viewColor
        
        let labelView = UILabel.appearance()
        labelView.textColor = labelColor
        
        let navigationView = UINavigationBar.appearance()
        navigationView.backgroundColor = navigationColor
        
        view?.backgroundColor = viewColor
        
        let tableView = UITableViewCell.appearance()
        tableView.backgroundColor = tableViewCellColor
        tableView.textLabel?.textColor = labelColor

 
    }
}
