//
//  DocumentService.swift
//  Navigation
//
//  Created by mitr on 26.07.2022.
//

import Foundation
import UIKit

// MARK: - DocumentServiceProtocol
protocol DocumentServiceProtocol {
    func contentsOfDirectory(url: URL, completion: @escaping (Result<[Document], Error>) -> Void)
    func createDirectory(title: String)
    func createFile(image: UIImage)
    func removeContent()
}

// MARK: - DocumentService
final class DocumentService: DocumentServiceProtocol {

    static let shared = DocumentService()
    private let fileManager = FileManager.default
    private let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    private init() {}

    // MARK: - contentsOfDirectory
    func contentsOfDirectory(url: URL, completion: @escaping (Result<[Document], Error>) -> Void) {

        var list: [Document] = []

        do {

            let contents = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

            for file in contents {
                if file.isDirectory {
                    list.append(Document(url: file, type: .folder))
                } else {
                    list.append(Document(url: file, type: .file))
                }

            }
        } catch {
            print(error.localizedDescription)
        }

        completion(.success(list))
    }

    // MARK: - createDirectory

    func createDirectory(title: String) {

        do {
            let directoryUrl = documentsUrl.appendingPathComponent(title)

            try fileManager.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)

        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - createFile
    func createFile(image: UIImage) {
        
        let date = Date()
        let format = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss")

        let fileUrl = documentsUrl.appendingPathComponent("изображение \(format)")

        guard let data = image.jpegData(compressionQuality: 1) else { return }

        if fileManager.fileExists(atPath: fileUrl.path) {
            do {
                try fileManager.removeItem(atPath: fileUrl.path)
            } catch {
                print(error.localizedDescription)
            }
        }

        do {
            try data.write(to: fileUrl)
        } catch {
            print(error.localizedDescription)
        }

    }

    func removeContent() {
        guard let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        do {

        } catch {
            print(error.localizedDescription)
        }
    }

}

// MARK: - extension URL
extension URL {
    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
