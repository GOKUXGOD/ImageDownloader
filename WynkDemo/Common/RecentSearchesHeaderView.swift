//
//  RecentSearchesHeaderView.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import UIKit

class RecentSearchesHeaderView: UICollectionReusableView {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpView() {
        addSubview(label)
        var constraints = [NSLayoutConstraint]()
        constraints.append(label.topAnchor.constraint(equalTo: topAnchor, constant: 10))
        constraints.append(label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4))
        constraints.append(label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8))
        constraints.append(label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8))
        NSLayoutConstraint.activate(constraints)
    }
}
