//
//  ImageDownloader.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 16/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public protocol PendingOperationProtocol {
    var downloadsInProgress: [IndexPath: Operation] { get set }
    var downloadQueue: OperationQueue { get set }

    func cancelAllOperations()
}

public class PendingOperations: PendingOperationProtocol {
    lazy public var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy public var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.Wynk.demo"
        return queue
    }()

    public func cancelAllOperations(){
        downloadQueue.cancelAllOperations()
    }
}

public class ImageDownloader: Operation {
    var searchItem: SearchItem
    let imageCache = NSCache<NSString, UIImage>()
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
