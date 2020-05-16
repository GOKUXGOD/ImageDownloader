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
    let reuseIdentifier = "SearchCell"
    private var dataSource: [SearchItem] = []

    private var viewModel: SearchViewModel!
    private let pendingOperations = PendingOperations()
    private let searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()

    private var centerLoader: UIActivityIndicatorView = {
        let centerLoader = UIActivityIndicatorView()
        centerLoader.translatesAutoresizingMaskIntoConstraints = false
        centerLoader.isHidden = true
        return centerLoader
    }()

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let spaceBetweenCells = CGFloat(8)
        let cellSize = UIScreen.main.bounds.width/CGFloat(3) - spaceBetweenCells
        layout.sectionInset = UIEdgeInsets(top: spaceBetweenCells/2, left: spaceBetweenCells/2, bottom: spaceBetweenCells/2, right: spaceBetweenCells/2)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = spaceBetweenCells/2
        return collectionView
    }()

    init(presenter: SearchResultsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)

        self.presenter.interface = self
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

    private func setUpSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }

    private func registerNibs() {
        collectionView.register(SearchResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func setUpView(with viewModel: SearchViewModel) {
        centerLoader.stopAnimating()
        self.viewModel = viewModel
        title = viewModel.title
        if dataSource.isEmpty {
            dataSource = viewModel.dataSource
            collectionView.reloadData()
        } else {
            setUpPaginationData(items: viewModel.dataSource)
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
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            centerLoader.startAnimating()
            presenter.searchText(text)
        }
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SearchResultsCell {
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
         loadImagesForOnscreenCells()
         resumeAllOperations()
       }
     }
     
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       loadImagesForOnscreenCells()
       resumeAllOperations()
     }
     
     // MARK: - operation management

    func suspendAllOperations() {
       pendingOperations.downloadQueue.isSuspended = true
     }
     
    func resumeAllOperations() {
       pendingOperations.downloadQueue.isSuspended = false
     }
     
    func loadImagesForOnscreenCells() {
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
