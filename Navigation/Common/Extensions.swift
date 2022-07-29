//
//  Extensions.swift
//  Navigation
//
//  Created by mitr on 20.03.2022.
//

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
