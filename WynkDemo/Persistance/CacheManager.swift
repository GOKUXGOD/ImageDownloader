//
//  CacheManager.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

public enum DownlodableState {
  case new, downloaded, failed

    init(state: SearchItemState) {
        switch state {
        case .downloaded:
            self = .downloaded
        case .failed:
            self = .failed
        case .new:
            self = .new
        }
    }
}

protocol Downlodable {
    var state: DownlodableState { get set }
    var image: UIImage? { get set }
    var url: String { get set }
}

class DownlodableItem: Downlodable {
    var state: DownlodableState
    var image: UIImage?
    var url: String
    
    init(state: DownlodableState,
         image: UIImage?,
         url: String) {
        self.state = state
        self.image = image
        self.url = url
    }

    init(searchItem: SearchItem) {
        self.image = searchItem.image
        self.url = searchItem.normalImageUrl ?? ""
        self.state = DownlodableState(state: searchItem.state)
    }
}

protocol CacheProtocol {
    var pendingOperations: PendingOperationProtocol { get set }
    func startDownloadForItem(item: Downlodable, completionHandler: @escaping CacheManagerCompletionHandler)
}

public protocol PendingOperationProtocol {
    var downloadsInProgress: [String: Operation] { get set }
    var downloadQueue: OperationQueue { get set }

    func cancelAllOperations()
}

public class PendingOperations: PendingOperationProtocol {
    lazy public var downloadsInProgress: [String: Operation] = [:]
    lazy public var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.Wynk.demo"
        return queue
    }()

    public func cancelAllOperations(){
        downloadQueue.cancelAllOperations()
    }
}

typealias CacheManagerCompletionHandler = (UIImage?, Error?) -> Void
public final class CacheManager: CacheProtocol {
    private var completionHandler = [String : CacheManagerCompletionHandler]()
    var pendingOperations: PendingOperationProtocol
    let imageCache = NSCache<NSString, UIImage>()

    init(pendingOperation: PendingOperationProtocol) {
        self.pendingOperations = pendingOperation
    }

    func startDownloadForItem(item: Downlodable, completionHandler: @escaping CacheManagerCompletionHandler) {
        let cachedUrl = item.url
        self.completionHandler[cachedUrl] = completionHandler
        
        if let cachedImage = imageCache.object(forKey: cachedUrl as NSString) {
            print("cached image returned")
            self.completionHandler[cachedUrl]!(cachedImage, nil)
            return
        }
        
        if let operation = pendingOperations.downloadsInProgress[cachedUrl] {
            print("already downloading the image returning ......")
            operation.queuePriority = .veryHigh
            return
        }

        print("starting new download")
        let downloader = ImageDownloader(item)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                if let image = downloader.image{
                    self.imageCache.setObject(image, forKey: cachedUrl as NSString)
                    self.pendingOperations.downloadsInProgress.removeValue(forKey: cachedUrl)
                    self.completionHandler[cachedUrl]!(image, nil)
                }else{
                    self.completionHandler[cachedUrl]!(nil, nil)
                }
            }
            print("download finish")
        }

        pendingOperations.downloadsInProgress[cachedUrl] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func cancelAllOperations(){
        pendingOperations.downloadQueue.cancelAllOperations()
        imageCache.removeAllObjects()
    }
}
