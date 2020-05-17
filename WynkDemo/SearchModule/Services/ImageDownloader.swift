//
//  ImageDownloader.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public class ImageDownloader: Operation {
    var searchItem: SearchItem
    var image: UIImage?
    init(_ photoRecord: SearchItem) {
        self.searchItem = photoRecord
    }

    override public func main() {
        if isCancelled {
            return
        }

        guard let imageUrl = URL(string: searchItem.normalImageUrl ?? ""),
            let imageData = try? Data(contentsOf: imageUrl) else {
                return
        }

        if isCancelled {
            return
        }

        if !imageData.isEmpty {
            self.image = UIImage(data:imageData)
            searchItem.image = UIImage(data:imageData)
            searchItem.state = .downloaded
        } else {
            searchItem.state = .failed
            searchItem.image = UIImage(named: "Failed")
        }
    }
}
