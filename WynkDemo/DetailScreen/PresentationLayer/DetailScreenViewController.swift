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
    private var currentIndex = 0 {
        willSet {
            if newValue == 0 {
                leftButton.isHidden = true
            } else if newValue == viewModel.photos.count - 1 {
                rightButton.isHidden = true
            } else {
                leftButton.isHidden = false
                rightButton.isHidden = false
            }
        }
    }

    private var leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.alpha = 0.8
        button.setImage(UIImage(named: "left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()

    private var rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.alpha = 0.8
        button.setImage(UIImage(named: "right"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()

    private var centerLoader: UIActivityIndicatorView = {
        let centerLoader = UIActivityIndicatorView(style: .large)
        centerLoader.translatesAutoresizingMaskIntoConstraints = false
        centerLoader.backgroundColor = .black
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
        self.currentIndex = viewModel.currentIndex

        super.init(nibName: nil, bundle: nil)

        self.presenter.interface = self
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        showCurrentImage()
    }

    public func setUpView(with data: DetailScreenViewModel) {
        let item = data.photos[data.currentIndex]
        imageView.contentMode = .scaleAspectFit
        imageView.image = item.image
    }

    public func setUpViewWithImage(image: UIImage) {
        centerLoader.stopAnimating()
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
    }

    public func setUpViewWithItems(items: [DetailItem]) {
        if viewModel.photos.isEmpty {
            viewModel.photos = items
            currentIndex = 0
        } else {
            currentIndex = viewModel.photos.count
            viewModel.photos.append(contentsOf: items)
        }
        showCurrentImage()
    }

    private func setUpView() {
        setUpContainerView()
        setUpImageView()
        setUpButtons()
        setUpLoader()
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
        constraints.append(imageView.topAnchor.constraint(equalTo: containerView.topAnchor))
        constraints.append(imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor))
        constraints.append(imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor))
        constraints.append(imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setUpButtons() {
        containerView.addSubview(leftButton)
        containerView.addSubview(rightButton)

        var constraints = [NSLayoutConstraint]()

        constraints.append(leftButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor))
        constraints.append(leftButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor))
        constraints.append(leftButton.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(leftButton.widthAnchor.constraint(equalToConstant: 50))

        constraints.append(rightButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor))
        constraints.append(rightButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor))
        constraints.append(rightButton.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(rightButton.widthAnchor.constraint(equalToConstant: 50))

        NSLayoutConstraint.activate(constraints)
    }

    private func fetchImageFromPresenter() {
        centerLoader.startAnimating()
        let item = viewModel.photos[self.currentIndex]
        presenter.fetchImageFor(item: item)
    }

    @objc func leftButtonTapped() {
        if currentIndex >= 0 {
            currentIndex -= 1
            showCurrentImage()
        }
    }

    @objc func rightButtonTapped() {
        if currentIndex < viewModel.photos.count - 1{
            currentIndex += 1
            showCurrentImage()
        }
        if currentIndex == viewModel.photos.count - 1 {
            presenter.searchText(viewModel.currentSearchText, offset: viewModel.photos.count, size: 3)
        }
    }

    private func showCurrentImage() {
        if let image = viewModel.photos[self.currentIndex].image {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            fetchImageFromPresenter()
        }
    }
}
