//
//  SceneDelegate.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let container: Container = {
        let container = Container()

        container.register(SearchApiServiceProtocol.self) { _ in
            let networkService = PixabayImagesClient()
            return SearchApiService(networkService: networkService)
        }

        container.register(SearchServiceProtocol.self) { resolver in
            let apiService = resolver.resolve(SearchApiServiceProtocol.self)!
            return SearchService(apiService: apiService)
        }

        container.register(SearchResultsInteractorInputProtocol.self) { resolver in
            let searchService = resolver.resolve(SearchServiceProtocol.self)!
            return SearchInteractor(searchService: searchService)
        }

        container.register(SearchResultsRouterInputProtocol.self) { _ in
            return SearchRouter()
        }

        container.register(PersistanceProtocol.self) { _ in
            return UserdefaultsHandler(persistance: UserDefaults.standard)
        }

        container.register(SearchResultsPresenterProtocol.self) { resolver in
            let interactor = resolver.resolve(SearchResultsInteractorInputProtocol.self)!
            let router = resolver.resolve(SearchResultsRouterInputProtocol.self)!
            let persistance = resolver.resolve(PersistanceProtocol.self)!

            return SearchPresenter(interactor: interactor, router: router, persistance: persistance)
        }
        
        container.register(PendingOperationProtocol.self) { resolver in
            return PendingOperations()
        }
        
        container.register(SearchViewModelProtocol.self) { resolver in
            var data: [PreviousSearchData] = []
            let persistance = resolver.resolve(PersistanceProtocol.self)!
            if let value = persistance.getvalue(for: .recentSearches) {
                data = value
            }
            return SearchViewModel(title: "Search", placeholder: "Search for anything", reuseIdentifier: "SearchCell", numberOfCellsInRow: 3, spaceBetweenCells: 10, persistance: persistance)
        }

        container.register(RecentSearchesInterface.self) { resolver in
            var data: [PreviousSearchData] = []
            let persistance = resolver.resolve(PersistanceProtocol.self)!
            if let value = persistance.getvalue(for: .recentSearches) {
                data = value
            }
            return RecentSearchesViewController(dataSource: data)
        }

        container.register(SearchResultsInterfaceProtocol.self) { resolver in
            let presenter = resolver.resolve(SearchResultsPresenterProtocol.self)!
            let pendingOperations = resolver.resolve(PendingOperationProtocol.self)!
            let viewModel = resolver.resolve(SearchViewModelProtocol.self)!
            let recentSearchesInterface = resolver.resolve(RecentSearchesInterface.self)!
            return SearchViewController(presenter: presenter, pendingOperations: pendingOperations, viewModel: viewModel, recentSearchesView: recentSearchesInterface)
        }

        return container
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        self.window = window
        // Instantiate the root view controller with dependencies injected by the container.
        let searchViewController = container.resolve(SearchResultsInterfaceProtocol.self) as? UIViewController
        window.rootViewController = UINavigationController(rootViewController: searchViewController!)
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

