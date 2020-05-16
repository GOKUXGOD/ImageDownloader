//
//  SearchApiServiceProtocol.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

public protocol SearchApiServiceProtocol {
    func fetchSearchResult(endpoint: SearchEndpoint,
                           success: ((SearchData) -> Void)?,
                           failure: ((APIError) -> Void)?)
}
