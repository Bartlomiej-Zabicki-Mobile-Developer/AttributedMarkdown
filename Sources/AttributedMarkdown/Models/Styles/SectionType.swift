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
    case alternateH1
    case alternateH2
    case body
    case blockquote
    case codeBlock
    case alternateCodeBlock
    case unorderedList
    case orderedList
    case bold
    case italic
    case image
    case link
}

extension SectionType {
    
    var isInLine: Bool {
        switch self {
        case .bold, .italic, .link: return true
        default: return false
        }
    }
    
}
