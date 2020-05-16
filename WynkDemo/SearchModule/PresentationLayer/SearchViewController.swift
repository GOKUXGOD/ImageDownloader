//
//  SearchViewController.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, SearchResultsInterfaceProtocol {
    var presenter: SearchResultsPresenterProtocol
    private var dataSource: [SearchItem] = []
    private let searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()

    init(presenter: SearchResultsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)

        self.presenter.interface = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchController()
        self.view.backgroundColor = .red
    }

    private func setUpSearchController() {
       // searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }

    func setUpView(with viewModel: SearchViewModel) {
        title = viewModel.title
        dataSource = viewModel.dataSource
    }
    
    deinit {
        print("vc deinit")
    }
}

 //extension SearchViewController: UISearchResultsUpdating {
//  func updateSearchResults(for searchController: UISearchController) {
//    if let text = searchController.searchBar.text {
//        presenter.searchText(text)
//    }
//  }
//}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter.searchText(text)
        }
    }
}
