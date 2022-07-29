//
//  Observable.swift
//  Navigation
//
//  Created by mitr on 16.07.2022.
//

import Foundation

final class Observable<T> {

    typealias Listener = (T) -> Void
    private var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        value = v
    }

}
