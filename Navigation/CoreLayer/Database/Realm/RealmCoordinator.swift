//
//  RealmCoordinator.swift
//  Navigation
//
//  Created by Dima Skvortsov on 08.08.2022.
//

import Foundation
import RealmSwift

final class RealmCoordinator {

    private let backgroundQueue = DispatchQueue(label: "RealmContext", qos: .background)
    private let mainQueue = DispatchQueue.main

    private func safeWrite(in realm: Realm, _ block: (() throws -> Void)) throws {
        realm.isInWriteTransaction
            ? try block()
            : try realm.write(block)
    }

}

extension RealmCoordinator: DatabaseCoordinatable {
    func update<T>(_ model: T.Type, predicate: NSPredicate?, keyedValues: [String : Any], completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        
    }
    
    func delete<T>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        
    }
    
    func deleteAll<T>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        
    }
    

    func create<T>(_ model: T.Type, keyedValues: [[String: Any]], completion: @escaping (Result<[T], DatabaseError>) -> Void) where T: Storable {
        do {
            let realm = try Realm()

            try safeWrite(in: realm) {
                guard let model = model as? Object.Type else {
                    completion(.failure(.wrongModel))
                    return
                }

                var objects: [Object] = []
                keyedValues.forEach {
                    let object = realm.create(model, value: $0, update: .all)
                    objects.append(object)
                }

                guard let result = objects as? [T] else {
                    completion(.failure(.wrongModel))
                    return
                }

                completion(.success(result))
            }
        } catch {
            completion(.failure(.error(description: "Ошибка записи объекта в БД")))
        }
    }

    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, completion: (Result<[T], DatabaseError>) -> Void) where T: Storable {

        do {
            let realm = try Realm()

            if let model = model as? Object.Type {
                var objects = realm.objects(model)
                if let predicate = predicate {
                    objects = objects.filter(predicate)
                }

                guard let results = Array(objects) as? [T] else {
                    completion(.failure(.wrongModel))
                    return
                }

                completion(.success(results))
            }
        } catch {
            completion(.failure(.error(description: "Ошибка извлечения объектов")))
        }
    }
    
    func fetchAll<T>(_ model: T.Type, completion: (Result<[T], DatabaseError>) -> Void) where T: Storable {
        fetch(model, predicate: nil, completion: completion)
    }
}
