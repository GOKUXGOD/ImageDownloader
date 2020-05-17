//
//  CacheManager.swift
//  WynkDemo
//
//  Created by Nitin Upadhyay on 17/05/20.
//  Copyright © 2020 Nitin Upadhyay. All rights reserved.
//

import Foundation
import UIKit

protocol CacheProtocol {
    var pendingOperations: PendingOperationProtocol { get set }
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

    func startDownloadForItem(searchItem: SearchItem, isLarge: Bool, completionHandler: @escaping CacheManagerCompletionHandler){
        guard let cachedUrl = isLarge ? searchItem.largeImageUrl : searchItem.normalImageUrl else {
            return
        }
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
        let downloader = ImageDownloader(searchItem)
        
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
        }

        pendingOperations.downloadsInProgress[cachedUrl] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func cancelAllOperations(){
        pendingOperations.downloadQueue.cancelAllOperations()
        imageCache.removeAllObjects()
    }
}
