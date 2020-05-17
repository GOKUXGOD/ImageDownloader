//
//  RecentSearchesViewController.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import UIKit

public protocol RecentSearchesViewDelegate: class {
    func didSelectRecentSearch(_ searchItem: PreviousSearchData)
}

public protocol RecentSearchesInterface {
    var dataSource: [PreviousSearchData] { get set }
    var delegate: RecentSearchesViewDelegate? { get set }

    func updateDatasource(_ value: [PreviousSearchData])
}

private enum ReuseIdentifier: String {
    case header
    case cell
}

class RecentSearchesViewController: UICollectionViewController, RecentSearchesInterface {
    var dataSource: [PreviousSearchData] {
        didSet {
            collectionView.reloadData()
        }
    }

    weak var delegate: RecentSearchesViewDelegate?

    init(dataSource: [PreviousSearchData]) {
        self.dataSource = dataSource
        let layout = UICollectionViewFlowLayout()
        let cellSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        super.init(collectionViewLayout: layout)
        registerNibs()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func registerNibs() {
        collectionView.register(PreviousSearchCell.self, forCellWithReuseIdentifier: ReuseIdentifier.cell.rawValue)
        collectionView.register(RecentSearchesHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ReuseIdentifier.header.rawValue)
    }
    
    func updateDatasource(_ value: [PreviousSearchData]) {
        dataSource = value
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.cell.rawValue, for: indexPath) as? PreviousSearchCell {
            cell.label.text = dataSource[indexPath.row].title
            return cell
        }
        fatalError()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectRecentSearch(dataSource[indexPath.row])
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                              withReuseIdentifier: ReuseIdentifier.header.rawValue,
                                                                              for: indexPath) as? RecentSearchesHeaderView {
            if dataSource.count > 0 {
                reusableview.label.text = "Recent Searches"
            }
            return reusableview
        } else {
            fatalError()
        }
    }
}
