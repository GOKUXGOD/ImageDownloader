//
//  SearchContracts.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public enum SearchError {
}

public enum SearchOperationState {
    case search
    case pagination
    case filter
}


// MARK: - Presenter to View

public protocol SearchResultsInterfaceProtocol: class {
    var presenter: SearchResultsPresenterProtocol { get }

    func setUpView(with data: [SearchItem])
}

// MARK: - View to Presenter

public protocol SearchResultsPresenterProtocol {
    var interface: SearchResultsInterfaceProtocol? { get set }
    var interactor: SearchResultsInteractorInputProtocol { get }
    var router: SearchResultsRouterInputProtocol { get }

    func searchText(_ text: String)
    func handleCellTap(currentIndex: Int, dataArray: [SearchItem], navigationController: UINavigationController)
}

// MARK: - Presenter to Interactor

public protocol SearchResultsInteractorInputProtocol {
    var presenter: SearchResultsInteractorOutputProtocol? { get set }

    func performSearchFor(_ text: String, offset: Int, size: Int)
}

// MARK: - Interactor to Presenter

public protocol SearchResultsInteractorOutputProtocol {
    func updateSearchWithData(_ data: SearchData?)
    func handleError(_ errorType: APIError, retryBlock: @escaping (() -> Void))
}

// MARK: - Presenter to Router

public protocol SearchResultsRouterInputProtocol {
    func showDetailPageFor(viewModel: DetailScreenViewModel, navController: UINavigationController)
}
