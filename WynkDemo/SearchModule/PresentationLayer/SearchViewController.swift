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
    var recentSearchesView: RecentSearchesInterface
    private var dataSource: [SearchItem] = []

    private var viewModel: SearchViewModelProtocol
    private var pendingOperations: PendingOperationProtocol
    private let searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()

    private var centerLoader: UIActivityIndicatorView = {
        let centerLoader = UIActivityIndicatorView()
        centerLoader.translatesAutoresizingMaskIntoConstraints = false
        centerLoader.isHidden = true
        return centerLoader
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        let spaceBetweenCells = CGFloat(viewModel.spaceBetweenCells)
        let cellSize = UIScreen.main.bounds.width/CGFloat(viewModel.numberOfCellsInRow) - spaceBetweenCells
        layout.sectionInset = UIEdgeInsets(top: spaceBetweenCells/2, left: spaceBetweenCells/2, bottom: spaceBetweenCells/2, right: spaceBetweenCells/2)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = spaceBetweenCells/2
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var recentSearchesViewController: RecentSearchesViewController {
        return recentSearchesView as! RecentSearchesViewController
    }

    init(presenter: SearchResultsPresenterProtocol, pendingOperations: PendingOperationProtocol, viewModel: SearchViewModelProtocol,
         recentSearchesView: RecentSearchesInterface) {
        self.presenter = presenter
        self.pendingOperations = pendingOperations
        self.viewModel = viewModel
        self.recentSearchesView = recentSearchesView

        super.init(nibName: nil, bundle: nil)

        self.presenter.interface = self
        self.recentSearchesView.delegate = self
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setUpView() {
        setUpCollectionView()
        setUpSearchController()
        setUpLoader()
        registerNibs()
        setUpRecentSearches()
    }

    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        var constraints = [NSLayoutConstraint]()
        constraints.append(collectionView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    private func setUpLoader() {
        view.addSubview(centerLoader)
        var constraints = [NSLayoutConstraint]()
        constraints.append(centerLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(centerLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    private func setUpRecentSearches() {
        view.addSubview(recentSearchesViewController.view)
        var constraints = [NSLayoutConstraint]()
        recentSearchesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(recentSearchesViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 80))
        constraints.append(recentSearchesViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(recentSearchesViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(recentSearchesViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    private func setUpSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = viewModel.placeholder
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }

    private func registerNibs() {
        collectionView.register(SearchResultsCell.self, forCellWithReuseIdentifier: viewModel.reuseIdentifier)
    }

    private func showRecentSearches() {
        recentSearchesViewController.view.isHidden = false
    }
    
    private func hideRecentSearches() {
        recentSearchesViewController.view.isHidden = true
    }

    func setUpView(with data: [SearchItem]) {
        centerLoader.stopAnimating()
        if dataSource.isEmpty {
            dataSource = data
            collectionView.reloadData()
        } else {
            setUpPaginationData(items: data)
        }
    }

    private func setUpPaginationData(items: [SearchItem]) {
        let indexPathsToReload = calculateIndexPathToReloadFrom(newAssets: items)
        dataSource.append(contentsOf: items)
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPathsToReload)
        }, completion: nil)
    }

    private func calculateIndexPathToReloadFrom(newAssets: [SearchItem]) -> [IndexPath] {
        let startIndex = dataSource.count
        let endIndex = startIndex + newAssets.count

        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

    private func perfromSearchFor(text: String) {
        centerLoader.startAnimating()
        presenter.searchText(text)
        hideRecentSearches()
    }

    private func startOperations(for searchItem: SearchItem, at indexPath: IndexPath, increasePriority: Bool) {
        switch (searchItem.state) {
        case .new:
            startDownload(for: searchItem, at: indexPath)
            if increasePriority {
                self.increasePriority(for: searchItem, at: indexPath)
            }
        case .downloaded, .failed:
            print("nothing required")
        }
    }

    func increasePriority(for searchItem: SearchItem, at indexPath: IndexPath) {
        guard let operation = pendingOperations.downloadsInProgress[indexPath] else {
            return
        }
        operation.queuePriority = .veryHigh
        print("priority Increased")
    }

    func startDownload(for searchItem: SearchItem, at indexPath: IndexPath) {
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
     
      let downloader = ImageDownloader(searchItem)
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }

        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else {
                return
            }
            sSelf.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            sSelf.collectionView.reloadItems(at: [indexPath])
        }
      }
      pendingOperations.downloadsInProgress[indexPath] = downloader
      pendingOperations.downloadQueue.addOperation(downloader)
    }

    deinit {
        print("vc deinit")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        dataSource = []
        collectionView.reloadData()
        pendingOperations.cancelAllOperations()
        if let searches = viewModel.persistance.getvalue(for: .recentSearches) {
            recentSearchesView.updateDatasource(searches)
        }
        showRecentSearches()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            perfromSearchFor(text: text)
        }
    }
}

extension SearchViewController: RecentSearchesViewDelegate {
    func didSelectRecentSearch(_ searchItem: PreviousSearchData) {
        searchController.searchBar.text = searchItem.title
        perfromSearchFor(text: searchItem.title)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath) as? SearchResultsCell {
            return cell
        }
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.count == indexPath.row + 1, let text = searchController.searchBar.text {
            presenter.searchText(text)
        }
        
        let assetDetails = dataSource[indexPath.row]
        if let cell = cell as? SearchResultsCell {
            switch assetDetails.state {
            case .new:
                cell.loader.startAnimating()
                if !collectionView.isDragging && !collectionView.isDecelerating {
                    startOperations(for: assetDetails, at: indexPath, increasePriority: false)
                }
                cell.imageView.image = UIImage(named: "placeholder")
                cell.loader.startAnimating()
            case .downloaded:
                cell.loader.stopAnimating()
                cell.imageView.image = assetDetails.image
            case .failed:
                cell.loader.stopAnimating()
                cell.imageView.image = UIImage(named: "failed")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let operation = pendingOperations.downloadsInProgress[indexPath] {
            operation.queuePriority = .veryLow
            print("priority decreases")
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
}

extension SearchViewController {
    // MARK: - scrollview delegate methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       suspendAllOperations()
     }
     
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       if !decelerate {
         loadImagesForVisibleCells()
         resumeAllOperations()
       }
     }
     
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       loadImagesForVisibleCells()
       resumeAllOperations()
     }
     
     // MARK: - operation management

    func suspendAllOperations() {
       pendingOperations.downloadQueue.isSuspended = true
     }
     
    func resumeAllOperations() {
       pendingOperations.downloadQueue.isSuspended = false
     }
     
    func loadImagesForVisibleCells() {
        let pathsArray = collectionView.indexPathsForVisibleItems
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)

        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsArray)
        toBeCancelled.subtract(visiblePaths)

        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        for indexPath in toBeCancelled {
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }

            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
        for indexPath in pathsArray {
            let recordToProcess = dataSource[indexPath.row]
            startOperations(for: recordToProcess, at: indexPath, increasePriority: true)
        }
    }
}
