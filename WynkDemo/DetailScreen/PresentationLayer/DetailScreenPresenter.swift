//
//  DetailScreenPresenter.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

final class DetailScreenPresenter: DetailScreenPresenterProtocol {
    var interface: DetailScreenInterfaceProtocol?
    var interactor: DetailScreenInteractorInputProtocol
    var router: DetailScreenRouterInputProtocol
    
    init(interactor: DetailScreenInteractorInputProtocol,
         router: DetailScreenRouterInputProtocol) {
        self.interactor = interactor
        self.router = router

        self.interactor.presenter = self
    }

    func searchText(_ text: String) {
    }

    func fetchImageFor(_ url: URL) {
        interactor.fetchImageFor(url: url)
    }
}

extension DetailScreenPresenter: DetailScreenInteractorOutputProtocol {
    func updateSearchWithData(_ data: SearchData?) {
    }

    func handleError(_ errorType: APIError, retryBlock: @escaping (() -> Void)) {
        print(errorType)
    }

    func updateWithImage(_ image: UIImage) {
    }
}
