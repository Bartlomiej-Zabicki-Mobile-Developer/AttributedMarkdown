//
//  ParserConfiguration.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import Foundation

public struct ParserConfiguration {
    public var sectionStyles: SectionStyles
    public var imagesHandler: ImagesHandler
    
    public static let `default` = ParserConfiguration(sectionStyles: .init(), imagesHandler: FilesImagesHandler())
    
    public init(sectionStyles: SectionStyles = .init(), imagesHandler: ImagesHandler = FilesImagesHandler()) {
        self.sectionStyles = sectionStyles
        self.imagesHandler = imagesHandler
    }
}
