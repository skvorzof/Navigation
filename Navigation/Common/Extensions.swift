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

extension UIColor {
    static var backgroundColor: UIColor {
        Self.makeColor(light: .white, dark: Color.backgroudColor)
    }

    static var textColor: UIColor {
        Self.makeColor(light: .black, dark: .white)
    }

    static var buttonBackground: UIColor {
        Self.makeColor(light: Color.accentColor, dark: Color.accentColor)
    }

    static var buttonDisabledBackground: UIColor {
        Self.makeColor(light: Color.disableColor, dark: Color.disableColor)
    }

    private static func makeColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return light
        }

        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? light : dark
        }
    }
}
