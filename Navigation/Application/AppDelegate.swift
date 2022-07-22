//
//  AppDelegate.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - AppConfiguration.getRandomUrl()
//        let randomUrl = AppConfiguration.getRandomUrl()
//        NetworkService.shared.getUrlSession(stingUrl: randomUrl)
        FirebaseApp.configure()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        do {
                try Auth.auth().signOut()
            } catch let error {
                print(error.localizedDescription)
            }
    }
}

