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
    private let baseUrl: String
    init(apiService: DetailScreenApiServiceProtocol,
         cachingService: CacheProtocol,
         baseUrl: String) {
        self.apiService = apiService
        self.cachingService = cachingService
        self.baseUrl = baseUrl
    }

    public func fetchSearchResult(searchKey: String, offset: Int, size: Int, success: ((SearchData) -> Void)?, failure: ((APIError) -> Void)?) {
        let urlStr = "\(baseUrl)&q=\(searchKey)&image_type=photo&page=\(offset)&per_page=\(size)"
        let endpoint = SearchEndpoint(url: URL.init(string: urlStr)!, httpMethod: "GET")
        apiService.fetchSearchResult(endpoint: endpoint, success: success, failure: failure)
    }

    public func fetchImage(item: Downlodable, success: ((UIImage) -> Void)?, failure: ((APIError) -> Void)?) {
        cachingService.startDownloadForItem(item: item) { (image, error) in
            if let image = image {
                success?(image)
            } else if let error = error{
                failure?(error)
            } else {
                failure?(APIError.requestFailed)
            }
        }
    }
}
