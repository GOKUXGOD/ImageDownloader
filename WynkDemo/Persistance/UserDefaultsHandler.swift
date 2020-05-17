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

   public func set(value: [PreviousSearchData]?, for key: PersistanceKey) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            persistance.set(encoded, forKey: key.rawValue)
        }
    }

    public func getvalue(for key: PersistanceKey) -> [PreviousSearchData]? {
        if let saved = persistance.object(forKey: key.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedItem = try? decoder.decode([PreviousSearchData].self, from: saved) {
                return loadedItem
            }
        }
        return nil
    }
}
