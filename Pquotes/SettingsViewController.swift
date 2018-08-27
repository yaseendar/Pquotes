//
//  SettingsViewController.swift
//  Pquotes
//
//  Created by Abdul Basit on 16/08/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit
import UserNotifications



@available(iOS 10.0, *)
class SettingsViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    
    
    let defaults = UserDefaults.standard
    static var title: String?
    static var quote : [String]?
    var isDarkTheme = false
    var  center = UNUserNotificationCenter.current()
    var cell : SettingsTableViewCell?
    
    @IBOutlet weak var nightModeLabel: UILabel!
    
    @IBOutlet weak var quoteOfTheDaySwitch: UISwitch!
    @IBOutlet weak var quoteOfTheDayLabel: UILabel!
    
    @IBOutlet weak var nightModeSwitch: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "settingscell", for: indexPath) as?SettingsTableViewCell
        let mySwitch: UISwitch = UISwitch(frame: CGRect.zero) as UISwitch
        mySwitch.tag = indexPath.row
        switch indexPath.row{
        case 0:
            cell?.settingsLabel.text  = "Show Quote Of The Day"
            quoteOfTheDaySwitch = mySwitch
            checkQuoteSwitchStatus()
            
        case 1:
            cell?.settingsLabel.text = "Night Mode"
            nightModeSwitch = mySwitch
               if defaults.bool(forKey: "DarkTheme"){
                nightModeSwitch.isOn = true
            }
               else{
                nightModeSwitch.isOn = false

            }
        default:
            cell?.settingsLabel.text = "Nothing"
        }
        checkNightModeSwitchStatus()
        mySwitch.addTarget(self, action: #selector(switchTriggered(sender:)), for: .valueChanged );
      
        cell?.accessoryView = mySwitch
        return cell!
    }
    
    func checkQuoteSwitchStatus(){

        
        if defaults.bool(forKey: "quoteFlag"){
            quoteOfTheDaySwitch.isOn = true
        }
        else{
            quoteOfTheDaySwitch.isOn = false
        }
        
    }
    
    func checkNightModeSwitchStatus(){
        if defaults.bool(forKey: "DarkTheme"){
            Theme.darkTheme(view: self.view)
           
            tableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cell?.backgroundColor = #colorLiteral(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
            cell?.settingsLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        else{
            Theme.defaultTheme(view: self.view)
            tableView.backgroundColor  = #colorLiteral(red: 0.9175666571, green: 0.9176985621, blue: 0.9175377488, alpha: 1)
            cell?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell?.settingsLabel?.textColor = #colorLiteral(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
            
        }
        
       
        
    }
    
    func switchTriggered(sender: AnyObject) {
        let mySwitch = sender as! UISwitch

        switch mySwitch.tag{
        case 0:
            quoteOfTheDayClicked(mySwitch)
        
        case 1:
            themeChangeClicked(mySwitch)
        default:
        print("not any of those")
        }
    }
    
    
  
    @IBAction func themeChangeClicked(_ sender: Any) {
        switch nightModeSwitch.isOn {
        case false:
            isDarkTheme = false
            self.defaults.set(isDarkTheme,forKey: "DarkTheme")
            Theme.defaultTheme(view:self.view)
            
           // quoteOfTheDayLabel.textColor = UIColor.black
           // nightModeLabel.textColor = UIColor.black
            
        case true:
            isDarkTheme = true
            self.defaults.set(isDarkTheme,forKey: "DarkTheme")
            Theme.darkTheme(view:self.view)
            
           // quoteOfTheDayLabel.textColor = UIColor.white
           // nightModeLabel.textColor = UIColor.white
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        
}
    @IBAction func quoteOfTheDayClicked(_ sender: Any) {
       if(quoteOfTheDaySwitch.isOn){
            defaults.set(true, forKey: "quoteFlag")
            
             center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert,.sound]
            
            
            center.requestAuthorization(options: options) { (authorized, error) in
                if (authorized && self.defaults.bool(forKey: "quoteFlag")){
                    print("def :\(self.defaults.bool(forKey: "quoteFlag"))")
                    
                 self.activateNotification()
                }
            }
            
        }
        else{
            defaults.set(false, forKey: "quoteFlag")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["exampleNotification"])
        }
    }
    
    func activateNotification(){
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["exampleNotification"])
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        var date = DateComponents()
        date.hour = 6
        date.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        //content.categoryIdentifier = categoryId
        
        CommentsViewController.getQuotesFromJson()
        var keys = Array(CommentsViewController.quotesData!.keys)
        SettingsViewController.title = keys[Int(arc4random_uniform(UInt32(keys.count)))]
        SettingsViewController.quote =  CommentsViewController.quotesData?[SettingsViewController.title!] as? [String]
        
        content.title = SettingsViewController.title!
        content.body = SettingsViewController.quote!.first!
        
        defaults.set(SettingsViewController.title!,forKey:"authors")
        
        let request = UNNotificationRequest(identifier: "exampleNotification", content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }
    
    
    
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["exampleNotification"])
    activateNotification()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "CommentsViewController")
  //  window?.rootViewController = vc
    self.present(vc,animated: true)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    @IBAction func quoteOfTheDayStateChanged(_ sender: Any) {
//        if(quoteOfTheDaySwitch.isOn){
//            defaults.set(true, forKey: "Notify")
//        }
//        else{
//            defaults.set(false,forKey: "Notify")
//        }
//    }
    
    
  
    
    

}
