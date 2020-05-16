//
//  Endpoint.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

protocol Endpoint {
    var url: URL {get}
    var httpMethod: String {get}
}

extension Endpoint {
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}


struct FlickerFeed: Endpoint {
    var url: URL
    var httpMethod: String
}
