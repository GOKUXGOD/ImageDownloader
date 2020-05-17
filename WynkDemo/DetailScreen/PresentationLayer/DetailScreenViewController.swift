//
//  DetailScreenViewController.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public final class DetailScreenViewController: UIViewController, DetailScreenInterfaceProtocol {
    public var presenter: DetailScreenPresenterProtocol
    public var viewModel: DetailScreenViewModelProtcol
    private var currentIndex = 0

    private var centerLoader: UIActivityIndicatorView = {
        let centerLoader = UIActivityIndicatorView()
        centerLoader.translatesAutoresizingMaskIntoConstraints = false
        centerLoader.isHidden = true
        return centerLoader
    }()

    private var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black

        return containerView
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    
        return imageView
    }()

    init(presenter: DetailScreenPresenterProtocol, viewModel: DetailScreenViewModelProtcol) {
        self.presenter = presenter
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = viewModel.photos[viewModel.currentIndex].image {
            imageView.image = image
        }
    }

    public func setUpView(with data: DetailScreenViewModel) {
        if let image = data.photos[data.currentIndex].image {
            imageView.image = image
        }
    }

    private func setUpView() {
        setUpContainerView()
        setUpLoader()
        setUpImageView()
    }

    private func setUpContainerView() {
        view.addSubview(containerView)
        var constraints = [NSLayoutConstraint]()
        constraints.append(containerView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    private func setUpLoader() {
        containerView.addSubview(centerLoader)
        var constraints = [NSLayoutConstraint]()
        constraints.append(centerLoader.centerYAnchor.constraint(equalTo: containerView.centerYAnchor))
        constraints.append(centerLoader.centerXAnchor.constraint(equalTo: containerView.centerXAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    private func setUpImageView() {
        containerView.addSubview(imageView)
        var constraints = [NSLayoutConstraint]()
        constraints.append(imageView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}
