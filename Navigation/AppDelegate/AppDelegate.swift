//
//  AppDelegate.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import FirebaseAuth
import FirebaseCore
import RealmSwift
import UIKit

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

    func inLibraryFolder(fileName: String) -> URL {
        return URL(
            fileURLWithPath: NSSearchPathForDirectoriesInDomains(
                .libraryDirectory,
                .userDomainMask,
                true
            )[0],
            isDirectory: true
        )
        .appendingPathComponent(fileName)
    }

    private func checkRealmMigration() {

        // SecKey = pass
        let secKey: [UInt8] = [0x70, 0x61, 0x73, 0x73]
        let data = Data(secKey)
        let key = String(data: data, encoding: .utf8)
        guard let key = key else { return }

        let config = Realm.Configuration(
            fileURL: inLibraryFolder(fileName: "encrypted.realm"), encryptionKey: key.sha512(),
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // on future migration
                }
            })

        Realm.Configuration.defaultConfiguration = config
    }
}
