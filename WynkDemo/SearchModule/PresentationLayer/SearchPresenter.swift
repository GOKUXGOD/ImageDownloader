//
//  SearchPresenter.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation

final class SearchPresenter: SearchResultsPresenterProtocol {
    weak var interface: SearchResultsInterfaceProtocol?
    var interactor: SearchResultsInteractorInputProtocol
    var router: SearchResultsRouterInputProtocol
    private var offset = 1
    private var size = 20
    private var currentSearchedText = ""
    init(interactor: SearchResultsInteractorInputProtocol,
         router: SearchResultsRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    
        self.interactor.presenter = self
    }

    func searchText(_ text: String) {
        if text != currentSearchedText {
            currentSearchedText = text
            offset = 1
        }
        interactor.performSearchFor(text, offset: offset, size: size)
    }
    
    func clearDataSource() {
    }
    
    func clearPreviousSearches() {
    }
    
    func handleCellTap(viewModel: SearchItem) {
    }
}

extension SearchPresenter: SearchResultsInteractorOutputProtocol {
    func updateSearchWithData(_ data: SearchData?) {
        if let data = data {
            interface?.setUpView(with: data.photos)
            offset += 1
        }
    }

    func handleError(_ errorType: APIError, retryBlock: @escaping (() -> Void)) {
        print(errorType)
    }
}
