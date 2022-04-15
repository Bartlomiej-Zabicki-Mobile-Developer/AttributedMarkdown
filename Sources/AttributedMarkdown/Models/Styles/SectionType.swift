//
//  File.swift
//  
//
//  Created by Bart on 09/04/2022.
//

import Foundation

enum SectionType: CaseIterable, Equatable {
    case h6
    case h5
    case h4
    case h3
    case h2
    case h1
    case body
    case blockquote
    case codeBlock
    case unorderedList
    case orderedList
    case bold
    case italic
    case image
    case link
    case paragraph
}

extension SectionType {
    
    var isInLine: Bool {
        switch self {
        case .bold, .italic, .link, .body: return true
        default: return false
        }
    }
    
    var defaultFontSize: CGFloat {
        switch self {
        case .h6:
            return 10
        case .h5:
            return 12
        case .h4:
            return 14
        case .h3:
            return 16
        case .h2:
            return 18
        case .h1:
            return 20
        case .body:
            return 16
        case .blockquote:
            return 16
        case .codeBlock:
            return 16
        case .unorderedList:
            return 14
        case .orderedList:
            return 16
        case .bold:
            return 16
        case .italic:
            return 16
        case .image:
            return 8
        case .link:
            return 16
        case .paragraph:
            return 16
        }
    }
    
}
