//
//  MigrationService.swift
//  Navigation
//
//  Created by Dima Skvortsov on 15.08.2022.
//

import Foundation

enum MigrationError: Error {
    case error(description: String)
}

protocol MigrationServiceProtocol: AnyObject {
    var coreDataCoordinator: DatabaseCoordinatable { get }
}

final class MigrationService {
    static let shared: MigrationServiceProtocol = MigrationService()
    let coreDataCoordinator: DatabaseCoordinatable
    
    private init() {
        self.coreDataCoordinator = Self.createDatabaseCoordinator()
    }
    
    private static func createDatabaseCoordinator() -> DatabaseCoordinatable {
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: "CoreDataModel", withExtension: "momd") else {
            fatalError("Can't find DataModel.xcdatamodelId in main Bundle")
        }
        
        switch CoreDataCoordinator.create(url: url) {
        case .success(let database):
            return database
        case .failure:
            switch CoreDataCoordinator.create(url: url) {
            case .success(let database):
                return database
            case .failure(let error):
                fatalError("Unable to create CoreData Database. Error - \(error.localizedDescription)")
            }
        }
    }
}

extension MigrationService: MigrationServiceProtocol {
    
}
