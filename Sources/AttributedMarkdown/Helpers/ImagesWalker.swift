//
//  ImagesWalker.swift
//  
//
//  Created by Bart on 16/04/2022.
//

import Foundation
import Markdown

struct ImagesWalker: MarkupWalker {
    
    var imageURLs: [String] = []
    
    // MARK: - Initialization
    
    internal init(imageURLs: [String] = []) {
        self.imageURLs = imageURLs
    }
    
    // MARK: - MarkupWalker
    
    mutating func visitImage(_ image: Markdown.Image) {
        if let source = image.source {
            imageURLs.append(source)
        }
        descendInto(image)
    }
    
}
