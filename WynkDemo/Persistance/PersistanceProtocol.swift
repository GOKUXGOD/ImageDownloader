//
//  PersistanceProtocol.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

public protocol PersistanceProtocol {
    func set<T>(value: T?, for key: PersistanceKey)
    func getvalue<T>(for key: PersistanceKey) -> T?
}

public enum PersistanceKey: String {
    case recentSearches
}
