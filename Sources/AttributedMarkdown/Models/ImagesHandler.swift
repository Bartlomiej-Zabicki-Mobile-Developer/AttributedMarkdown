//
//  File.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import Foundation

protocol ImagesHandler {
    func urlToSave(remoteURL: URL) -> URL?
}

public struct FilesImagesHandler: ImagesHandler {
    
    let mainDirectory = "AttributedMarkdown/Images"
    
    // MARK: - ImagesHandler
    
    func urlToSave(remoteURL: URL) -> URL? {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagePath = remoteURL.pathComponents.filter({ $0 != "/" }).joined(separator: "_")
        documentsURL?.appendPathComponent(imagePath)
        return documentsURL
    }
    
}
