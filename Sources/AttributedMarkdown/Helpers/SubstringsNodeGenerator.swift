//
//  File.swift
//  
//
//  Created by Bart on 21/02/2022.
//

import Foundation

typealias Node = SubstringsNodeGenerator.Node

struct MarkdownNodeCandidate: Equatable {
    let nodeType: Node.NodeType
    let tokenType: SubSectionRule.TokenType
    let token: SubSectionRule.Token
    let rule: SubSectionRule
}

final class SubstringsNodeGenerator {
    
    private static let maxTokensCount: Int? = SubSectionType.allCases.compactMap({ $0.rule })
        .compactMap({ $0.tokens.compactMap({ $0.token.count })})
        .flatMap({ $0 })
        .max(by: { $0 > $1 }) ?? 0
    
    private struct NodeFindResult {
        let nodeType: Node.NodeType
        let token: SubSectionRule.Token
        let indexAfterNode: Substring.Index
    }
    
    func findNodes(in sourceString: Substring) -> [Node] {
        var index: Int = 0
        var nodes: [Node] = []
        var lastOpenedNode: Node?
        
        while index < sourceString.count {
            var canOpenNewNode = true
            if let closeResult = nodeTypeForCloseCharacter(as: sourceString.index(sourceString.startIndex, offsetBy: index), in: sourceString, parent: nil) {
                canOpenNewNode = lastOpenedNode?.closeParent(nodeType: closeResult.nodeType) != true // didn't close parent or parent is nil
                if let innerLastOpenedNode = lastOpenedNode, innerLastOpenedNode.isClosed == true {
//                    nodes.append(innerLastOpenedNode)
                    lastOpenedNode = nil
                    index += closeResult.token.token.count
                }
            }
            print("Cannot find close result")
            let stringIndex = sourceString.index(sourceString.startIndex, offsetBy: index, limitedBy: sourceString.endIndex)
            if let stringIndex = stringIndex,
                index < sourceString.count,
               canOpenNewNode, let openResult = nodeTypeForOpenCharacter(as: stringIndex, in: sourceString, parent: nil) {
                let indexOfNewContent = sourceString.index(sourceString.startIndex, offsetBy: index + openResult.token.token.count, limitedBy: sourceString.index(before: sourceString.endIndex))
                if let innerLastOpenedNode = lastOpenedNode, let indexOfNewContent = indexOfNewContent {
                    let child: Node = .init(content: Substring(String(.init(unicodeScalarLiteral: sourceString[indexOfNewContent]))), type: openResult.nodeType, parent: lastOpenedNode, children: [])
                    lastOpenedNode?.children.append(child)
                    if lastOpenedNode?.parent == nil {
                        nodes.append(innerLastOpenedNode)
                    }
                    lastOpenedNode = child
                    index += openResult.token.token.count + 1
                    continue
//                    break
                } else {
                    lastOpenedNode = .init(content: Substring(String(.init(unicodeScalarLiteral: sourceString[stringIndex]))), type: openResult.nodeType, parent: lastOpenedNode, children: [])
                    index += 1
                    continue
//                    break
                }
            }
            if let stringIndex = stringIndex,
               sourceString.indices.contains(stringIndex){
                let character = sourceString[stringIndex]
                let content: Substring = Substring(String(.init(unicodeScalarLiteral: sourceString[stringIndex])))
                if let lastOpenedNode = lastOpenedNode {
                    lastOpenedNode.content.append(character)
                } else {
                    lastOpenedNode = .init(content: content, type: .body, parent: nil, children: [])
                }
            }
            index += 1
            
        }
        
        if let lastOpenedNode = lastOpenedNode, !nodes.contains(lastOpenedNode) {
            nodes.append(lastOpenedNode)
        }
        return nodes
    }
    
    // MARK: - Private implementation
    
    private func nodeTypeForOpenCharacter(as index: Substring.Index, in sourceString: Substring, parent: Node?) -> NodeFindResult? {
        guard let nodeCandidates = sourceString[index].markdownNodeCandidates, !nodeCandidates.isEmpty else { return nil }
        let tokenCandidates = nodeCandidates.filter({ $0.tokenType == .open }).filter({ candidate in
            var isValidCandidate = true
            guard isValidCandidate else { return false }
            if let endIndex = sourceString.index(index, offsetBy: candidate.token.token.count, limitedBy: sourceString.endIndex) {
                let substring = sourceString[index..<endIndex]
                isValidCandidate = substring == Substring(candidate.token.token)
                
            } else {
                isValidCandidate = false
            }
            return isValidCandidate
        })
//        let tokenCandidates = nodeCandidates.filter({ $0.tokenType == .open }).filter({ candidate in
//                var isValidCandidate = true
//                candidate.token.token.enumerated().forEach { offset, character in
//                    guard isValidCandidate else { return }
//                    if let additionalIndex = sourceString.index(index, offsetBy: offset, limitedBy: sourceString.endIndex),
//                        let candidateIndex = candidate.token.token.index(candidate.token.token.startIndex,
//                                                                         offsetBy: offset, limitedBy: candidate.token.token.endIndex),
//                        String(sourceString[sourceString.index(additionalIndex, offsetBy: -1)..<additionalIndex]) == String(candidate.token.token[candidateIndex]) {
//                        isValidCandidate = true
//                    } else {
//                        isValidCandidate = false
//                    }
//                }
//                return isValidCandidate
//            })
        guard let firstCandidate = tokenCandidates.first(where: { $0.tokenType == .open}) else { return nil }
        return .init(nodeType: firstCandidate.nodeType, token: firstCandidate.token, indexAfterNode: sourceString.index(index, offsetBy: firstCandidate.token.token.count))
    }
    
    private func nodeTypeForCloseCharacter(as index: Substring.Index, in sourceString: Substring, parent: Node?) -> NodeFindResult? {
        guard let nodeCandidates = sourceString[index].markdownNodeCandidates, !nodeCandidates.isEmpty else { return nil }
        print("Node candidates: \(nodeCandidates)")
        let tokenCandidates = nodeCandidates.filter({ $0.tokenType == .close }).filter({ candidate in
                var isValidCandidate = true
//            candidate.token.token.forEach { token in
                    guard isValidCandidate else { return false}
            if let endIndex = sourceString.index(index, offsetBy: candidate.token.token.count, limitedBy: sourceString.endIndex) {
                let substring = sourceString[index..<endIndex]
                isValidCandidate = substring == Substring(candidate.token.token)
                
            } else {
                isValidCandidate = false
            }
//                    if let additionalIndex = sourceString.index(index, offsetBy: offset, limitedBy: sourceString.endIndex),
//                        let candidateIndex = candidate.token.token.index(candidate.token.token.startIndex, offsetBy: offset,
//                                                                         limitedBy: candidate.token.token.endIndex),
//                       String(sourceString[sourceString.index(additionalIndex, offsetBy: -1)..<additionalIndex]) == String(candidate.token.token[candidateIndex]) {
//                        isValidCandidate = true
//                    } else {
//                        isValidCandidate = false
//                    }
//                }
                return isValidCandidate
            })
        guard let firstCandidate = tokenCandidates.first else { return nil }
        return .init(nodeType: firstCandidate.nodeType, token: firstCandidate.token, indexAfterNode: sourceString.index(index, offsetBy: firstCandidate.token.token.count - 1))
    }
    
}

private extension Substring {
    
//    subscript(safeIndex: Substring.Index) -> Character? {
//        guard self.indices.contains(safeIndex) else { return nil }
//        return self[safeIndex]
//    }
//
//    subscript(safeIndex: Int) -> Character? {
//        guard self.indices.count > safeIndex else { return nil }
//        return self[safeIndex]
//    }
    
}

private extension String {
    
//    subscript(safeIndex: Substring.Index) -> Character? {
//        guard self.indices.contains(safeIndex) else { return nil }
//        return self[safeIndex]
//    }
//
//    subscript(safeIndex: Int) -> Character? {
//        guard self.indices.count > safeIndex else { return nil }
//        return self[safeIndex]
//    }
    
}

private extension Character {
    
    var isMarkdownToken: Bool {
//        !SubSectionType.allCases.compactMap({ $0.rule }).compactMap({ $0.tokens.compactMap({ $0.token }) }).filter({ $0.contains(where: { $0.contains(self) }) }).isEmpty
        return markdownNodeCandidates != nil && markdownNodeCandidates?.isEmpty == false
    }
    
    var markdownNodeCandidates: [MarkdownNodeCandidate]? {
        SubSectionType.allCases.compactMap({ $0.rule })
            .map({ rule -> [MarkdownNodeCandidate]? in
                let tokens = rule.tokens.filter({ $0.token.contains(self) })
                guard !tokens.isEmpty else { return nil }
                return tokens.compactMap { token in
                    return .init(nodeType: .init(from: rule.type), tokenType: token.type, token: token, rule: rule)
                }
            })
            .compactMap({ $0 })
            .flatMap({ $0 })
    }
    
}

extension SubstringsNodeGenerator {
    
    final class Node: Equatable {
        
        static func == (lhs: SubstringsNodeGenerator.Node, rhs: SubstringsNodeGenerator.Node) -> Bool {
            lhs.content == rhs.content && lhs.type == rhs.type && lhs.parent == rhs.parent && lhs.isClosed == rhs.isClosed //&& lhs.children == rhs.children
        }
        
        
        enum NodeType: String, Equatable {
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
        var content: Substring
        let type: NodeType
        var parent: Node?
        var children: [Node]
        var isClosed: Bool = false
        
        init(content: Substring,
             type: NodeType,
             parent: Node?,
             children: [Node],
             isClosed: Bool = false) {
            self.content = content
            self.type = type
            self.parent = parent
            self.children = children
            self.isClosed = isClosed
        }
        
        func closeParent(nodeType: NodeType) -> Bool {
            print("CloseParent: \(nodeType), my: \(type)")
            if type == nodeType, !isClosed {
                isClosed = true
                return true
            } else if let parent = parent {
                return parent.closeParent(nodeType: nodeType)
            } else {
                return false
            }
        }
    }
    
}
    
