//
//  ImagesRewriter.swift
//  
//
//  Created by Bart on 16/04/2022.
//

import Foundation
import Markdown

struct ImageOutput {
    let remoteURL: URL
    let localURL: URL?
}

struct ImagesRewriter: MarkupRewriter {
    
    var imageOutputs: [ImageOutput]
    
    // MARK: - Initialization
    
    internal init(imageOutputs: [ImageOutput] = []) {
        self.imageOutputs = imageOutputs
    }
    
    // MARK: - MarkupWalker
    
    mutating func visitImage(_ image: Markdown.Image) -> Markup? {
        if let fetchedOutput = imageOutputs.first(where: { $0.remoteURL.absoluteString == image.source }), let localURL = fetchedOutput.localURL {
            var image = image
            image.source = localURL.path
            return image
        } else {
            return image
        }
    }
    
}
