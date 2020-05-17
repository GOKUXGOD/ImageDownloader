//
//  DetailScreenServiceProtocol.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public protocol DetailScreenServiceProtocol {
    func fetchSearchResult(searchKey: String,
                           offset: Int,
                           size: Int,
                           success: ((SearchData) -> Void)?,
                           failure: ((APIError) -> Void)?)

    func fetchImage(item: Downlodable,
                    success: ((UIImage) -> Void)?,
                    failure: ((APIError) -> Void)?)
}
