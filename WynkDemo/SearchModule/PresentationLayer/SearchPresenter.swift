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

    init(interactor: SearchResultsInteractorInputProtocol,
         router: SearchResultsRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    
        self.interactor.presenter = self
    }

    func searchText(_ text: String) {
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
            let viewModel = SearchViewModel(title: "Search", dataSource: data.photos)
            interface?.setUpView(with: viewModel)
           // offset += size
        }
    }

    func handleError(_ errorType: APIError, retryBlock: @escaping (() -> Void)) {
        print(errorType)
    }
}
