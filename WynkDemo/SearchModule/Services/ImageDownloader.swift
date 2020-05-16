//
//  ImageDownloader.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
}

public class ImageDownloader: Operation {
    var searchItem: SearchItem

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
            searchItem.image = UIImage(data:imageData)
            searchItem.state = .downloaded
        } else {
            searchItem.state = .failed
            searchItem.image = UIImage(named: "Failed")
        }
    }
}
