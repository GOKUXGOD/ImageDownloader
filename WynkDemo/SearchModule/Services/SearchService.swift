//
//  SearchService.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation


public struct SearchQueryParam: Codable {
    public let searchKey: String?
    public let offset: Int?
    public let size: Int?
    public let itemTypeString: String?

    public init(searchKey: String?,
                offset: Int?,
                size: Int?,
                itemType: String?) {
        self.searchKey = searchKey
        self.offset = offset
        self.size = size
        self.itemTypeString = itemType
    }

    enum CodingKeys: String, CodingKey {
        case searchKey = "text_search"
        case offset, size
        case itemTypeString = "item_type"
    }
}

public final class SearchService: SearchServiceProtocol {
    private let apiService: SearchApiServiceProtocol
    private let baseUrl: String

    init(apiService: SearchApiServiceProtocol,
         baseUrl: String) {
        self.apiService = apiService
        self.baseUrl = baseUrl
    }

    public func fetchSearchResult(searchKey: String, offset: Int, size: Int, success: ((SearchData) -> Void)?, failure: ((APIError) -> Void)?) {
        let urlStr = "\(baseUrl)&q=\(searchKey)&image_type=photo&page=\(offset)&per_page=\(size)"
        let endpoint = SearchEndpoint(url: URL.init(string: urlStr)!, httpMethod: "GET")
        apiService.fetchSearchResult(endpoint: endpoint, success: success, failure: failure)
    }
}
