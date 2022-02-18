//
//  SubSectionRule.swift
//  
//
//  Created by Bart on 03/02/2022.
//

import Foundation

enum TokenCountType {
    case moreOrEqualThan
    case sameAs
}

struct SubSectionRule {
    
    struct Token {
        let token: String
        let count: Int
        let countType: TokenCountType
        let type: TokenType
    }
    
    typealias Tokens = [Token]
    
    enum TokenType {
        case open, close, metadataOpen, metadataClose
    }
    let openToken: Token
    let otherTokens: Tokens
    let type: SubSectionType
}
