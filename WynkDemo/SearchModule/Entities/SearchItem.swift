//
//  SearchItem.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public enum SearchItemState {
  case new, downloaded, failed
}

public class SearchItem: Codable {
    public let itemID: Int?
    public let normalImageUrl: String?
    public let largeImageUrl: String?
    public var state = SearchItemState.new
    public var image: UIImage? = UIImage(named: "placeholder")

    enum CodingKeys: String, CodingKey {
        case itemID = "id"
        case normalImageUrl = "previewURL"
        case largeImageUrl = "largeImageURL"
    }
}

public struct SearchData: Codable {
    public let photos: [SearchItem]

    enum CodingKeys: String, CodingKey {
        case photos = "hits"
    }
}
