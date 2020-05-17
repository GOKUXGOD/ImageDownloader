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
    var downlodableItem: Downlodable
    var image: UIImage?

    init(_ photoRecord: Downlodable) {
        self.downlodableItem = photoRecord
    }

    override public func main() {
        if isCancelled {
            return
        }

        guard let imageUrl = URL(string: downlodableItem.url),
            let imageData = try? Data(contentsOf: imageUrl) else {
                return
        }

        if isCancelled {
            return
        }

        if !imageData.isEmpty, let image = UIImage(data:imageData) {
            self.image = image
            downlodableItem.image = image
            downlodableItem.state = .downloaded
        } else {
            downlodableItem.state = .failed
            downlodableItem.image = UIImage(named: "Failed")
        }
    }
}
