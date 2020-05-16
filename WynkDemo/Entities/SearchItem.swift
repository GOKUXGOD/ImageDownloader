//
//  SearchItem.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

public struct SearchItem: Codable {
    public let itemID: Int?
    public let normalImageUrl: String?
    public let largeImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "id"
        case normalImageUrl = "webformatURL"
        case largeImageUrl = "largeImageURL"
    }
}

public struct SearchData: Codable {
    public let photos: [SearchItem]

    enum CodingKeys: String, CodingKey {
        case photos = "hits"
    }
}
