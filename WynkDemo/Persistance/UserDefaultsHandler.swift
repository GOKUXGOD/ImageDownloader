//
//  UserDefaultsHandler.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
public class UserdefaultsHandler: PersistanceProtocol {
    let persistance: UserDefaults

    init(persistance: UserDefaults) {
        self.persistance = persistance
    }

    public func set<T>(value: T?, for key: PersistanceKey) {
        persistance.set(value, forKey: key.rawValue)
    }

    public func getvalue<T>(for key: PersistanceKey) -> T? {
        let value = persistance.value(forKey: key.rawValue) as? T
        return value
    }
}
