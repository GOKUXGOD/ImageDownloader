//
//  DetailScreenContracts.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public enum DetailScreenError {
}

// MARK: - Presenter to View

public protocol DetailScreenInterfaceProtocol: class {
    var presenter: DetailScreenPresenterProtocol { get }
    var viewModel: DetailScreenViewModelProtcol { get set }

    func setUpView(with data: DetailScreenViewModel)
}

// MARK: - View to Presenter

public protocol DetailScreenPresenterProtocol {
    var interface: DetailScreenInterfaceProtocol? { get set }
    var interactor: DetailScreenInteractorInputProtocol { get }
    var router: DetailScreenRouterInputProtocol { get }

    func searchText(_ text: String)
    func fetchImageFor(_ url: URL)
}

// MARK: - Presenter to Interactor

public protocol DetailScreenInteractorInputProtocol {
    var presenter: DetailScreenInteractorOutputProtocol? { get set }

    func performSearchFor(_ text: String, offset: Int, size: Int)
    func fetchImageFor(url: URL)
}

// MARK: - Interactor to Presenter

public protocol DetailScreenInteractorOutputProtocol {
    func updateSearchWithData(_ data: SearchData?)
    func updateWithImage(_ image: UIImage)
    func handleError(_ errorType: APIError, retryBlock: @escaping (() -> Void))
}

// MARK: - Presenter to Router

public protocol DetailScreenRouterInputProtocol {
}
