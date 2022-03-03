//
//  File.swift
//  
//
//  Created by Bart on 21/02/2022.
//

import Foundation

typealias Node = SubstringsNodeGenerator.Node

final class SubstringsNodeGenerator {
    
    struct Node: Equatable {
        
        enum NodeType {
            case bold
            case italic
            case image
            case link
            case body
            
            init(from source: SubSectionType) {
                switch source {
                case .bold, .alternateBold:
                    self = .bold
                case .italic, .alteranteItalic:
                    self = .italic
                case .image:
                    self = .image
                case .link:
                    self = .link
                case .body:
                    self = .body
                }
            }
        }
        /*
         Content of the tag without tag
         */
        let content: Substring
        let type: NodeType
        let rangeInOrigin: ClosedRange<String.Index>
        let children: [Node]
    }
    
    func findNodes(in sourceString: Substring) -> [Node] {
        var nodes: [Node] = []
        var lastNodeEndIndex: String.Index { nodes.sorted(by: { $0.rangeInOrigin.upperBound > $1.rangeInOrigin.upperBound }).first?.rangeInOrigin.upperBound ?? sourceString.startIndex }
        
        while let node = findNode(after: lastNodeEndIndex, in: sourceString) {
            let fillingRangeEndIndex = node.rangeInOrigin.lowerBound == sourceString.startIndex ? node.rangeInOrigin.lowerBound : sourceString.index(before: node.rangeInOrigin.lowerBound)
            let fillingRange = lastNodeEndIndex...fillingRangeEndIndex
            if let fillingNode = generateFillNode(between: fillingRange, in: sourceString) {
                nodes.append(fillingNode)
            }
            nodes.append(node)
        }
        
        if sourceString.index(after: lastNodeEndIndex) < sourceString.index(before: sourceString.endIndex) {
            let range = sourceString.index(after: lastNodeEndIndex)...sourceString.index(before: sourceString.endIndex)
            let content = sourceString[range]
            nodes.append(.init(content: content, type: .body, rangeInOrigin: range, children: []))
        }
        
        if nodes.isEmpty {
            nodes = [
                .init(content: sourceString, type: .body, rangeInOrigin: sourceString.startIndex...sourceString.endIndex, children: [])
            ]
        }
        
        return nodes
    }
    
    private func findNode(after index: String.Index, in source: Substring) -> Node? {
        print("Finding node after: \(index) = \(source[index...])")
        var node: Node?
        SubSectionType.allCases
            .filter({ $0.rule != nil })
            .forEach { subSectionType in
            guard node == nil else { return }
                let foundNode = findNode(of: subSectionType.rule!, in: source[index...])
            node = foundNode
        }
        return node
    }
    
    private func generateFillNode(between range: ClosedRange<String.Index>, in source: Substring) -> Node? {
        guard !range.isEmpty, range.lowerBound != range.upperBound else { return nil }
        let rangeInOrigin = range.lowerBound...range.upperBound
        let content = source[rangeInOrigin]
        return .init(content: content, type: .body, rangeInOrigin: rangeInOrigin, children: [])
    }
    
    func findNode(of subSectionRule: SubSectionRule, in sourceString: Substring) -> Node? {
        ///Check if string contains openToken
        guard let openRange = sourceString.range(of: subSectionRule.openToken.token) else { return nil }
        var modifiedContent = sourceString
        ///Check if subsection needs close tag, if not range beginning with open tag is returned
        guard let closeToken = subSectionRule.otherTokens.first(where: { $0.type == .close }) else {
            let range = openRange.lowerBound...sourceString.endIndex
            let openTokenCount = subSectionRule.openToken.token.endIndex
            modifiedContent.removeSubrange(openRange)
            
            return .init(content: modifiedContent, type: .init(from: subSectionRule.type), rangeInOrigin: openRange.lowerBound...openTokenCount, children: [])
        }
        ///Check sourceString contains closeToken after openToken
        modifiedContent.replaceSubrange(openRange, with: "")
        if let closeRange = modifiedContent
//               .replacingOccurrences(of: subSectionRule.openToken.token, with: "", options: [], range: nil)
               .range(of: closeToken.token) {
            
            let closeTokenCloseRangeIndex = sourceString.index(closeRange.upperBound, offsetBy: -1)
            
            let openTokenEndIndex = sourceString.index(closeRange.upperBound, offsetBy: .init(subSectionRule.openToken.count - 1))
            
            let range = openRange.upperBound...closeTokenCloseRangeIndex
            
            let modifiedContent = sourceString[range]
            
            return .init(content: modifiedContent, type: .init(from: subSectionRule.type), rangeInOrigin: openRange.lowerBound...openTokenEndIndex, children: [])
        }
        ///sourceString contains openToken but doesn't contain closeToken
        return nil
    }
    
}
