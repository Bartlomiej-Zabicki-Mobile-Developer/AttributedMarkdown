//
//  SubSectionType.swift
//  
//
//  Created by Bart on 01/02/2022.
//

import Foundation

enum SubSectionType: CaseIterable {
    case bold
    case alternateBold
    case italic
    case alteranteItalic
    case image
    case link
    case body
}

extension SubSectionType {
    
    var rule: SubSectionRule? {
        switch self {
        case .bold:
            return .init(openToken: .init(token: "**", count: 2, countType: .moreOrEqualThan, type: .open),
                         otherTokens: [
                            .init(token: "**", count: 2, countType: .moreOrEqualThan, type: .close)
                         ], type: self)
        case .alternateBold:
            return .init(openToken:  .init(token: "__", count: 2, countType: .moreOrEqualThan, type: .open), otherTokens: [], type: self)
        case .italic:
            return .init(openToken:  .init(token: "*", count: 1, countType: .sameAs, type: .open),
                         otherTokens: [
                            .init(token: "*", count: 1, countType: .sameAs, type: .open)
                         ], type: self)
        case .alteranteItalic:
            return .init(openToken:  .init(token: "_", count: 1, countType: .sameAs, type: .open),
                         otherTokens: [
                            .init(token: "_", count: 1, countType: .sameAs, type: .open)
                         ], type: self)
        case .image:
            return .init(openToken:  .init(token: "[", count: 1, countType: .sameAs, type: .open),
                         otherTokens: [
                            .init(token: "]", count: 1, countType: .sameAs, type: .open)
                         ], type: self)
        case .link:
            return .init(openToken:  .init(token: "(", count: 1, countType: .sameAs, type: .open),
                         otherTokens: [
                            .init(token: ")", count: 1, countType: .sameAs, type: .open)
                         ], type: self)
        case .body: return nil
        }
    }
    
}
