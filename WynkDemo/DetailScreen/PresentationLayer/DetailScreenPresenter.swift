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

    func searchText(_ text: String, offset: Int, size: Int) {
        interactor.performSearchFor(text,offset: offset, size: size)
    }

    func fetchImageFor(item: DetailItem) {
        let downloadableItem = DownlodableItem(state: .new, image: nil, url: item.imageUrl ?? "")
        interactor.fetchImageFor(item: downloadableItem)
    }
}

extension DetailScreenPresenter: DetailScreenInteractorOutputProtocol {
    func updateSearchWithData(_ data: SearchData?) {
        if let data = data {
            let items = data.photos.map { DetailItem(item: $0) }
            interface?.setUpViewWithItems(items: items)
        }
    }

    func handleError(_ errorType: APIError, retryBlock: @escaping (() -> Void)) {
        print(errorType)
    }

    func updateWithImage(_ image: UIImage) {
        interface?.setUpViewWithImage(image: image)
    }
}
