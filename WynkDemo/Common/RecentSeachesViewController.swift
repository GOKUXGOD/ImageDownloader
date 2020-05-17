//
//  RecentSearchesViewController.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PreviousSearchCell"

public protocol RecentSearchesInterface {
    var dataSource: [PreviousSearchData] { get set }

    func updateDatasource(_ value: [PreviousSearchData])
}

class RecentSearchesViewController: UICollectionViewController, RecentSearchesInterface {
    var dataSource: [PreviousSearchData] {
        didSet {
            collectionView.reloadData()
        }
    }

    init(dataSource: [PreviousSearchData]) {
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(PreviousSearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PreviousSearchCell {
            cell.label.text = dataSource[indexPath.row].title
        }
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

