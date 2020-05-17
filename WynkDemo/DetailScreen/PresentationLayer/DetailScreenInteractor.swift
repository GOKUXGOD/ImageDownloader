//
//  DetailScreenInteractor.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
final class DetailScreenInteractor: DetailScreenInteractorInputProtocol {
    var presenter: DetailScreenInteractorOutputProtocol?

    private let detailService: DetailScreenServiceProtocol!

    init(detailService: DetailScreenServiceProtocol) {
        self.detailService = detailService
    }

    func fetchImageFor(item: Downlodable) {
        detailService.fetchImage(item: item, success: { [weak self] image in
            guard let sSelf = self else {
                return
            }
            sSelf.presenter?.updateWithImage(image)
        }) { [weak self] error in
            guard let sSelf = self else {
                return
            }
            sSelf.presenter?.handleError(error, retryBlock: {})
        }
    }

    func performSearchFor(_ text: String, offset: Int, size: Int) {
        if let encodedString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            detailService.fetchSearchResult(searchKey: encodedString, offset: offset, size: size, success: { [weak self] searchData in
                guard let sSelf = self else {
                    return
                }
                sSelf.presenter?.updateSearchWithData(searchData)
            }) { [weak self] error in
                guard let sSelf = self else {
                    return
                }
                sSelf.presenter?.handleError(error, retryBlock: {})
            }
        }
    }
}
