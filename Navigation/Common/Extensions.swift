//
//  Extensions.swift
//  Navigation
//
//  Created by mitr on 20.03.2022.
//

import CommonCrypto
import UIKit

extension UIView {
    static var identifier: String {
        String(describing: self)
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension String {
    func sha512() -> Data? {
        let stringData = data(using: String.Encoding.utf8)!
        var result = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes { resultBytes in
            stringData.withUnsafeBytes { stringBytes in
                CC_SHA512(stringBytes, CC_LONG(stringData.count), resultBytes)
            }
        }
        return result
    }
}


