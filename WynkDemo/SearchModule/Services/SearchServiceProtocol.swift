//
//  SearchServiceProtocol.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

public protocol SearchServiceProtocol {
    func fetchSearchResult(searchKey: String,
                           offset: Int,
                           size: Int,
                           success: ((SearchData) -> Void)?,
                           failure: ((APIError) -> Void)?)
}
