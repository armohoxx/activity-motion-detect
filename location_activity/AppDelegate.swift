//
//  AppDelegate.swift
//  location_activity
//
//  Created by phattarapon on 21/7/2565 BE.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window? = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = assignViewController()
        self.window?.makeKeyAndVisible()
        self.createTableHistory()
        LocationHelper.shared().update()
        
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

