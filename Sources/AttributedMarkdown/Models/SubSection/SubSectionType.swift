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
            return .init(openToken: .init(token: "**", count: 2, type: .open),
                         closeToken: .init(token: "**", count: 2, type: .close),
                                      metadataTokens: [], type: self)
        case .alternateBold:
            return .init(openToken:  .init(token: "__", count: 2, type: .open),
                         closeToken:  .init(token: "__", count: 2, type: .close),
                         metadataTokens: [], type: self)
        case .italic:
            return .init(openToken:  .init(token: "*", count: 1, type: .open),
                         closeToken: .init(token: "*", count: 1, type: .close),
                         metadataTokens: [], type: self)
        case .alteranteItalic:
            return .init(openToken:  .init(token: "_", count: 1, type: .open),
                         closeToken: .init(token: "_", count: 1, type: .close),
                         metadataTokens: [], type: self)
        case .image:
            return .init(openToken:  .init(token: "[", count: 1, type: .open),
                         closeToken: .init(token: "]", count: 1, type: .close),
                         metadataTokens: [
                            .init(token: "(", count: 1, type: .metadataOpen),
                            .init(token: ")", count: 1, type: .metadataClose)
                         ], type: self)
        case .link:
            return .init(openToken:  .init(token: "![", count: 1, type: .open),
                         closeToken: .init(token: "]", count: 1, type: .close),
                         metadataTokens: [
                            .init(token: "(", count: 1, type: .metadataOpen),
                            .init(token: ")", count: 1, type: .metadataClose)
                         ], type: self)
        case .body: return nil
        }
    }
    
}
