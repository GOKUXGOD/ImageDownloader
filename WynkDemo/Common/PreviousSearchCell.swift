//
//  PreviousSearchCell.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import UIKit

class PreviousSearchCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.clipsToBounds = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(label)
        setupConstraints()
        backgroundColor = .black
    }

    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(label.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4))
        constraints.append(label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8))
        constraints.append(label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8))
        NSLayoutConstraint.activate(constraints)
    }
}
