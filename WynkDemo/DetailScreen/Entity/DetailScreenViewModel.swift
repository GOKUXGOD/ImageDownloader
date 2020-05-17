//
//  DetailScreenViewModel.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public protocol DetailItemProtocol {
    var image: UIImage? { get set}
    var imageUrl: String? { get set }
    var id: Int? { get set }
}

public struct DetailItem: DetailItemProtocol {
    public var image: UIImage?
    public var imageUrl: String?
    public var id: Int?

    public init(image: UIImage?, imageUrl: String?, id: Int?) {
        self.image = image
        self.imageUrl = imageUrl
        self.id = id
    }

    public init(item: SearchItem) {
        self.image = item.image
        self.imageUrl = item.largeImageUrl
        self.id = item.itemID
    }
}

public protocol DetailScreenViewModelProtcol {
    var photos: [DetailItem] { get set }
    var currentIndex: Int { get set }
    var currentSearchText: String { get set }
}

public struct DetailScreenViewModel: DetailScreenViewModelProtcol {
    public var photos: [DetailItem]
    public var currentIndex: Int
    public var currentSearchText: String

    init(photos: [DetailItem], currentIndex: Int,
         currentSearchText: String) {
        self.photos = photos
        self.currentIndex = currentIndex
        self.currentSearchText = currentSearchText
    }
}
