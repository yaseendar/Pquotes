//
//  AppDelegate.swift
//  Pquotes
//
//  Created by Yaseen Dar on 29/03/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import Fabric

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{

    var window: UIWindow?
    static var title: String?
    static var quote : [String]?
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true

        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()

        if  ((launchOptions?[.localNotification] as? NSDictionary) != nil){
            ViewController.fromNotification = true
        }
        
        sleep(2)
        activateNotifications()

        
     //   DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
           
     //   }
      
        
       
        return true
    }
    
    /*func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController
        window?.rootViewController = vc
    }*/
    

    func activateNotifications(){
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["exampleNotification"])
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert,.sound]
        center.delegate = self
        
        center.requestAuthorization(options: options) { (authorized, error) in
            if (authorized && self.defaults.bool(forKey: "quoteFlag")){
                print("def :\(self.defaults.bool(forKey: "quoteFlag"))")
                
                //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                var date = DateComponents()
                date.hour = 12
                date.minute = 43
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                
                let content = UNMutableNotificationContent()
                content.sound = UNNotificationSound.default()
                
                ViewController.authorFromNotification = self.defaults.string(forKey: "authors")!
                
                CommentsViewController.getQuotesFromJson()
                var keys = Array(CommentsViewController.quotesData!.keys)
                AppDelegate.title = keys[Int(arc4random_uniform(UInt32(keys.count)))]
                AppDelegate.quote =  CommentsViewController.quotesData?[AppDelegate.title!] as? [String]
                
                content.title = AppDelegate.title!
                content.body = AppDelegate.quote!.first!
                
                self.defaults.set(AppDelegate.title!, forKey: "authors")
                
                let request = UNNotificationRequest(identifier: "exampleNotification", content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
                
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      

        ViewController.fromNotification = true
        //activateNotifications()
    
          self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()

      
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        activateNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    }


}

