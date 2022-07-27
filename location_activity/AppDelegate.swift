//
//  AppDelegate.swift
//  location_activity
//
//  Created by phattarapon on 21/7/2565 BE.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseMessaging
import XCGLogger

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window? = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = assignViewController()
        self.window?.makeKeyAndVisible()
        self.createTableHistory()
        
        //MARK: remote config error no google service file
        //FirebaseApp.configure()
        
        if #available(iOS 13.0, *) {
            self.customizeNavigationBar()
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func assignViewController() -> UIViewController {
        return MainRouter.createModule()
    }
    
    func createTableHistory() {
        let database = DBActivity.sharedInstance
        database.createTable()
    }
    
    @available(iOS 13.0, *)
    func customizeNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = appearance;
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
        UINavigationBar.appearance().isTranslucent = true
        appearance.backgroundColor = .white
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your applicati on supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        LocationUpdater.shared.startUpdater()
        ActivityMotion.shared.startActivityUpdates()
        //UNUserNotificationCenter.current().delegate = self
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        LocationUpdater.shared.startUpdater()
        ActivityMotion.shared.startActivityUpdates()
        //UNUserNotificationCenter.current().delegate = self
        
        //UserSession.shared.syncPairedWristband(doneCallback: nil)
        RemoteConfigHelper.shared.fetchRemoteSponsorImage()
        //self.checkMinimumRequiredPermission()
        //self.checkVerifyQuarantineUsingWristband()
        //self.checkTimeViedoCall()
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

