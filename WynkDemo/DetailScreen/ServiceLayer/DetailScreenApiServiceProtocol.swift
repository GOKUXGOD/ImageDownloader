//
//  DetailScreenApiServiceProtocol.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
public protocol DetailScreenApiServiceProtocol {
    func fetchSearchResult(endpoint: SearchEndpoint,
                           success: ((SearchData) -> Void)?,
                           failure: ((APIError) -> Void)?)
    func fetchImage(searchKey: String,
                           success: ((SearchData) -> Void)?,
                           failure: ((APIError) -> Void)?)
}
