//
//  SectionType.swift
//  
//
//  Created by Bart on 23/01/2022.
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
}

extension SectionType {
    
    var styleKeyPath: KeyPath<SectionStyles, Style> {
        switch self {
        case .h6:
            return \.h6
        case .h5:
            return \.h5
        case .h4:
            return \.h4
        case .h3:
            return \.h3
        case .h2, .alternateH2:
            return \.h2
        case .h1, .alternateH1:
            return \.h1
        case .body:
            return \.body
        case .blockquote:
            return \.blockquote
        case .codeBlock, .alternateCodeBlock:
            return \.codeBlock
        case .unorderedList:
            return \.unorderedList
        case .orderedList:
            return \.orderedList
        }
    }
    
    var rule: SectionRule? {
        switch self {
        case .h6:
            return .init(token: "######", type: .h6, removeRule: .both)
        case .h5:
            return .init(token: "#####", type: .h5, removeRule: .both)
        case .h4:
            return .init(token: "####", type: .h4, removeRule: .both)
        case .h3:
            return .init(token: "###", type: .h3, removeRule: .both)
        case .h2:
            return .init(token: "##", type: .h2, removeRule: .both)
        case .h1:
            return .init(token: "#", type: .h1, removeRule: .both)
        case .alternateH1:
            return .init(token: "=", type: .alternateH1, removeRule: .entireLine)
        case .alternateH2:
            return .init(token: "-", type: .alternateH2, removeRule: .entireLine)
        case .blockquote:
            return .init(token: ">", type: .blockquote, removeRule: .leading)
        case .codeBlock:
            return .init(token: "    ", type: .codeBlock, removeRule: .leading)
        case .alternateCodeBlock:
            return .init(token: "\t", type: .codeBlock, removeRule: .leading)
        case .unorderedList:
            return .init(token: "* ", type: .unorderedList, removeRule: .leading)
        case .orderedList:
            return .init(token: "1. ", type: .orderedList, removeRule: .leading)
        case .body:
            return nil
        }
    }
    
    var influencesPreviousLine: Bool {
        switch self {
        case .alternateH1, .alternateH2: return true
        default: return false
        }
    }
    
}
