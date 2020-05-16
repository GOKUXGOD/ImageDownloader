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
    var placeholder: String { get set }
    var reuseIdentifier: String { get set }
    var numberOfCellsInRow: Int { get set }
    var spaceBetweenCells: Int { get set }
}

public struct SearchViewModel: SearchViewModelProtocol {
    var title: String
    var placeholder: String
    var reuseIdentifier: String
    var numberOfCellsInRow: Int
    var spaceBetweenCells: Int

    init(title: String, placeholder: String, reuseIdentifier: String, numberOfCellsInRow: Int, spaceBetweenCells: Int) {
        self.title = title
        self.placeholder = placeholder
        self.reuseIdentifier = reuseIdentifier
        self.numberOfCellsInRow = numberOfCellsInRow
        self.spaceBetweenCells = spaceBetweenCells
    }
}
