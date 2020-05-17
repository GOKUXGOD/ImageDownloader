//
//  DetailScreenService.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public final class DetailScreenService: DetailScreenServiceProtocol {
    private let apiService: DetailScreenApiServiceProtocol
    private let cachingService: CacheProtocol
    init(apiService: DetailScreenApiServiceProtocol,
         cachingService: CacheProtocol) {
        self.apiService = apiService
        self.cachingService = cachingService
    }

    public func fetchSearchResult(searchKey: String, offset: Int, size: Int, success: ((SearchData) -> Void)?, failure: ((APIError) -> Void)?) {
        let urlStr = "https://pixabay.com/api/?key=16572321-abb986fe5cfd7ca7d3e003593&q=\(searchKey)&image_type=photo&page=\(offset)&per_page=\(size)"
        let endpoint = SearchEndpoint(url: URL.init(string: urlStr)!, httpMethod: "GET")
        apiService.fetchSearchResult(endpoint: endpoint, success: success, failure: failure)
    }

    public func fetchImage(searchKey: URL,
                    success: ((UIImage) -> Void)?,
                    failure: ((APIError) -> Void)?) {
        
    }
}
