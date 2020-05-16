//
//  ViewController.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = PixabayImagesClient()
        let pageNumber = 1
        let searchText = "messi"
        guard let url = URL(string: "https://pixabay.com/api/?key=16572321-abb986fe5cfd7ca7d3e003593&q=yellow+flowers&image_type=photo&page=1&per_page=5") else {return}
        let endpoint = SearchEndpoint(url: url, httpMethod: "GET")
        request.getFeed(endpoint: endpoint) { [weak self] result in
            switch result{
            case .success(let result):
                if let items = result?.photos {
                 print(items.count)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
