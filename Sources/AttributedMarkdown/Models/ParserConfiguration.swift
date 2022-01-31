//
//  ParserConfiguration.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import Foundation

public struct ParserConfiguration {
    let sectionStyles: SectionStyles
    let imagesHandler: ImagesHandler
    
    static let `default` = ParserConfiguration(sectionStyles: .init(), imagesHandler: FilesImagesHandler())
}
