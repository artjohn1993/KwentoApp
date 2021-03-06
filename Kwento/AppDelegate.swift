//
//  AppDelegate.swift
//  Kwento
//
//  Created by Richtone Hangad on 05/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.5)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setupAppearance()
//        MSAppCenter.start("cc3c42a3-360c-4f7d-8a11-82df9053980a", withServices:[
//          MSAnalytics.self,
//          MSCrashes.self
//        ])
        MSAppCenter.start("88f03a2a-eac8-470a-85a4-9857f49dc33e", withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        
        var serviceData = CoreDataServices()
        var userInfo = [UserInfo]()
            serviceData.getUserInfo { (result) in
                userInfo = result ?? []
                if userInfo.count > 0 {
                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "DashBoardId") as! DashboardController
                    self.window?.rootViewController = viewController
                    self.window?.makeKeyAndVisible()
                }
                else {
                    print("App delegate else")
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "LoginStoryBoardId") as! LoginController
                    self.window?.rootViewController = viewController
                    self.window?.makeKeyAndVisible()
                }

        }
         
        GIDSignIn.sharedInstance()?.clientID = "705534798950-gq6b3n68aavh8d6bhhqk803qk0pf7rnf.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
      let email = user.profile.email
        
//        print(email)
//        print(fullName)
//        print(userId)
//        print(idToken)
      // ...
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let facebook = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        let google = GIDSignIn.sharedInstance().handle(url)
        
        return facebook || google
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        PersistenceService.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Kwento")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Theming
    
    func setupAppearance() {
        IQKeyboardManager.shared.enable = true
        
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [HowItWorksPageController.self])
        pageControl.currentPageIndicatorTintColor = .main
        pageControl.pageIndicatorTintColor = UIColor.main.withAlphaComponent(0.2)
    }
    
 

}

