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

struct SubSectionRule: Equatable {
    
    struct Token: Equatable {
        let token: String
        let count: Int
        let type: TokenType
    }
    
    typealias Tokens = [Token]
    
    enum TokenType: String, Equatable {
        case open, close, metadataOpen, metadataClose
    }
    let openToken: Token
    let closeToken: Token
    let metadataTokens: Tokens
    let type: SubSectionType
    
    var tokens: Tokens {
       [openToken, closeToken] + metadataTokens
    }
}
