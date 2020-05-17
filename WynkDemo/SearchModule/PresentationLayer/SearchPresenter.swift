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
    var persistance: PersistanceProtocol
    private var offset = 1
    private var size = 20
    private var currentSearchedText = ""
    private var kPreviosSearchesMaxCount = 10

    init(interactor: SearchResultsInteractorInputProtocol,
         router: SearchResultsRouterInputProtocol,
         persistance: PersistanceProtocol) {
        self.interactor = interactor
        self.router = router
        self.persistance = persistance

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
    
    private func saveSearchedItem(_ item: String) {
        guard !item.isEmpty else {
            return
        }
        if var existingItems = persistance.getvalue(for: .recentSearches) {
            if existingItems.count <= kPreviosSearchesMaxCount {
                var index = 0
                var isItemPresent = false
                for (cIndex, cItem) in existingItems.enumerated() where item == cItem.title {
                    index = cIndex
                    isItemPresent = true
                }
                if !isItemPresent {
                    if existingItems.count == kPreviosSearchesMaxCount {
                        existingItems.removeLast()
                    }
                    existingItems.insert(PreviousSearchData(title: item), at: 0)
                } else if isItemPresent {
                    existingItems.move(from: index, to: 0)
                }
                persistance.set(value: existingItems, for: .recentSearches)
            }
        } else {
            persistance.set(value: [PreviousSearchData(title: item)], for: .recentSearches)
        }
    }
}

extension SearchPresenter: SearchResultsInteractorOutputProtocol {
    func updateSearchWithData(_ data: SearchData?) {
        if let data = data {
            interface?.setUpView(with: data.photos)
            offset += 1
            if data.photos.count > 0 {
                saveSearchedItem(currentSearchedText)
            }
        }
    }

    func handleError(_ errorType: APIError, retryBlock: @escaping (() -> Void)) {
        print(errorType)
    }
}
