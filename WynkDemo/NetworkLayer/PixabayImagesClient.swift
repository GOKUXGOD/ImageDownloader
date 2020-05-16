//
//  PixabayImagesClient.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

public class PixabayImagesClient: APIClient {
    let session: URLSession

    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    convenience init() {
        self.init(configuration: .default)
    }

    func getFeed(endpoint: SearchEndpoint, completion: @escaping (Result<SearchData?, APIError>) -> Void) {
        let request = endpoint.request
        fetch(with: request, decode: { json -> SearchData? in
            guard let result = json as? SearchData else { return  nil }
            return result
        }, completion: completion)
    }
}
