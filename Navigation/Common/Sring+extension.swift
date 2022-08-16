//
//  Sring+extension.swift
//  Navigation
//
//  Created by Dima Skvortsov on 15.08.2022.
//

import Foundation

extension String {
    /// Замена паттерна строкой.
    /// - Parameters:
    ///   - pattern: Regex pattern.
    ///   - replacement: Строка, на что заменить паттерн.
    func replace(_ pattern: String, replacement: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        return regex.stringByReplacingMatches(in: self,
                                              options: [.withTransparentBounds],
                                              range: NSRange(location: 0, length: self.count),
                                              withTemplate: replacement)
    }
}
