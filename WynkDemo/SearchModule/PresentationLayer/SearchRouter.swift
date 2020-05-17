//
//  SearchRouter.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import Swinject

public final class SearchRouter: SearchResultsRouterInputProtocol {
    init() {
    }
    public func showDetailPageFor(viewModel: DetailScreenViewModel, navController: UINavigationController) {
        let container = Container()

        container.register(DetailScreenApiServiceProtocol.self) { _ in
            let networkService = PixabayImagesClient()
            return DetailScreenApiService(networkService: networkService)
        }
        
        container.register(PendingOperationProtocol.self) { _ in
            return PendingOperations()
        }

        container.register(CacheProtocol.self) { resolver in
            let pendingOperations = resolver.resolve(PendingOperationProtocol.self)!
            return CacheManager(pendingOperation: pendingOperations)
        }

        container.register(DetailScreenServiceProtocol.self) { resolver in
            let apiService = resolver.resolve(DetailScreenApiServiceProtocol.self)!
            let cachingService = resolver.resolve(CacheProtocol.self)!
            return DetailScreenService(apiService: apiService, cachingService: cachingService)
        }

        container.register(DetailScreenInteractorInputProtocol.self) { resolver in
            let detailService = resolver.resolve(DetailScreenServiceProtocol.self)!
            return DetailScreenInteractor(detailService: detailService)
        }

        container.register(DetailScreenRouterInputProtocol.self) { _ in
            return DetailScreenRouter()
        }

        container.register(DetailScreenPresenterProtocol.self) { resolver in
            let interactor = resolver.resolve(DetailScreenInteractorInputProtocol.self)!
            let router = resolver.resolve(DetailScreenRouterInputProtocol.self)!

            return DetailScreenPresenter(interactor: interactor, router: router)
        }
        
        container.register(DetailScreenViewModelProtcol.self) { resolver in
            return DetailScreenViewModel(photos: viewModel.photos, currentIndex: viewModel.currentIndex, currentSearchText: viewModel.currentSearchText)
        }

        container.register(DetailScreenInterfaceProtocol.self) { resolver in
            let presenter = resolver.resolve(DetailScreenPresenterProtocol.self)!
            let viewModel = resolver.resolve(DetailScreenViewModelProtcol.self)!

            return DetailScreenViewController(presenter: presenter, viewModel: viewModel)
        }

        let controller = container.resolve(DetailScreenInterfaceProtocol.self) as! UIViewController
        navController.modalPresentationStyle = .fullScreen
        navController.present(controller, animated: true, completion: nil)
    }
}
