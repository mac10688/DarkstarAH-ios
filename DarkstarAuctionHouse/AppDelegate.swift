//
//  AppDelegate.swift
//  DarkstarAuctionHouse
//
//  Created by Matthew Cooper on 9/7/17.
//  Copyright © 2017 Darkstar. All rights reserved.
//

import UIKit
import PopupDialog
import RxMoya
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        deleteDatabase()
        createDatabase()
        return true
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
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Prepare the popup assets
        let title = "Initial Sync"
        let message = "Initialize the items."
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let buttonOne = DefaultButton(title: "You should sync") {
            
            darkstarProvider.rx.request(.weapons).subscribe { event in
                switch(event) {
                case let .success(response):
                        do {
                            let json = try response.mapJSON() as! [Any]
                            for weaponJson in json {
                                let weapon = WeaponItem(json: weaponJson as! [String : Any])
                                insertWeaponItem(weapon: weapon)
                            }
                        }
                        catch let error as NSError {
                            print(error.description)
                        }
                    
                case let .error(error):
                    print(error)
                }
            }
            
            darkstarProvider.request(.armors, completion: { result in
                if let data = result.value {
                    do {
                        let jsonArray = try data.mapJSON() as! [Any]
                        for json in jsonArray {
                            let armor = ArmorItem(json: json as! [String : Any])
                            insertArmorItem(armor: armor)
                        }
                    }
                    catch let error as NSError {
                        print(error.description)
                    }
                }
            })
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne])
        
        // Present dialog
        UIApplication.shared.keyWindow?.rootViewController?.present(popup, animated: true, completion: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


