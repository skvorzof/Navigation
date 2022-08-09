//
//  AppDelegate.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import FirebaseAuth
import FirebaseCore
import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MARK: - AppConfiguration.getRandomUrl()
        //        let randomUrl = AppConfiguration.getRandomUrl()
        //        NetworkService.shared.getUrlSession(stingUrl: randomUrl)
        checkRealmMigration()
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
    
    private func checkRealmMigration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // on future migration
                }
        })

        Realm.Configuration.defaultConfiguration = config
    }
}
