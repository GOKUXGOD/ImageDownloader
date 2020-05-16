//
//  SearchResultsCell.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import UIKit

class SearchResultsCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var loader: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(loader)
        setupConstraints()
    }

    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(imageView.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        constraints.append(imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(loader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        constraints.append(loader.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        NSLayoutConstraint.activate(constraints)
    }

}
