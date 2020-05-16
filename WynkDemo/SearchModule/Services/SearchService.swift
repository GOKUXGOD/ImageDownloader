//
//  SearchService.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

public final class SearchService: SearchServiceProtocol {
    private let apiService: SearchApiServiceProtocol
    
    init(apiService: SearchApiServiceProtocol) {
        self.apiService = apiService
    }

    public func fetchSearchResult(success: ((SearchData) -> Void)?, failure: ((APIError) -> Void)?) {
        let endpoint = SearchEndpoint(url: URL.init(string: "")!, httpMethod: "GET")
        apiService.fetchSearchResult(endpoint: endpoint, success: success, failure: failure)
    }
}
