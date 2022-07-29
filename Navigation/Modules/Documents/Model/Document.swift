//
//  Document.swift
//  Navigation
//
//  Created by mitr on 26.07.2022.
//

import Foundation

enum DocumentType {
    case file
    case folder
}

struct Document {
    let url: URL
    let type: DocumentType
}
