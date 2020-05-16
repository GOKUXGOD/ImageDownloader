//
//  SearchViewModel.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
protocol SearchViewModelProtocol {
    var title: String { get set }
    var dataSource: [SearchItem] { get set }
    var placeholder: String { get set }
    var reuseIdentifier: String { get set }
}

public struct SearchViewModel: SearchViewModelProtocol {
    var title: String
    var dataSource: [SearchItem]
    var placeholder: String
    var reuseIdentifier: String

    init(title: String, dataSource: [SearchItem], placeholder: String, reuseIdentifier: String) {
        self.title = title
        self.dataSource = dataSource
        self.placeholder = placeholder
        self.reuseIdentifier = reuseIdentifier
    }
}
