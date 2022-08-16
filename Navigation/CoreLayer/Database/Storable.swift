//
//  Storable.swift
//  Navigation
//
//  Created by Dima Skvortsov on 08.08.2022.
//

import RealmSwift
import CoreData

protocol Storable {}

extension Object: Storable {}
extension NSManagedObject: Storable {}
