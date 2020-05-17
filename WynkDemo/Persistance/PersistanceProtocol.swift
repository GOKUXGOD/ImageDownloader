//
//  PersistanceProtocol.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

public protocol PersistanceProtocol {
    func set(value: [PreviousSearchData]?, for key: PersistanceKey)
    func getvalue(for key: PersistanceKey) -> [PreviousSearchData]?
}

public enum PersistanceKey: String {
    case recentSearches
}
