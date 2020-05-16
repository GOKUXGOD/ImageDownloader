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
}

public struct SearchViewModel: SearchViewModelProtocol {
    var title: String
    var dataSource: [SearchItem]

    init(title: String, dataSource: [SearchItem]) {
        self.title = title
        self.dataSource = dataSource
    }
}
