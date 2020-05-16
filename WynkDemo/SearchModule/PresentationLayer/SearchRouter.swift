//
//  SearchRouter.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
public final class SearchRouter: SearchResultsRouterInputProtocol {
    public var openDetailPage: ((SearchItem) -> Void)?

    init() {
    }
}
