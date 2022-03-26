//
//  File.swift
//  
//
//  Created by Bart on 21/02/2022.
//

import Foundation

typealias Node = SubstringsNodeGenerator.Node

struct MarkdownNodeCandidate: Equatable {
    let subsectionType: SubSectionType
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
        let nodeType: SubSectionType
        let token: SubSectionRule.Token
        let indexAfterNode: Substring.Index
    }
    
    func findNodes(in sourceString: Substring) -> [Node] {
        var index: Int = 0
        var nodes: [Node] = []
        var lastOpenedNode: Node?
        
        while index < sourceString.count {
            var canOpenNewNode = true
            if let closeResults = nodeTypesForCloseCharacter(as: sourceString.index(sourceString.startIndex, offsetBy: index), in: sourceString, parent: nil) {
                canOpenNewNode = lastOpenedNode?.closeParent(nodeTypes: closeResults.compactMap({ $0.nodeType })) != true // didn't close parent or parent is nil
                
                let closeResultMaxTokenCount = closeResults.compactMap({ $0.token.token.count }).max() ?? 0
                
                if let innerLastOpenedNode = lastOpenedNode, innerLastOpenedNode.isClosed == true {
                    if nodes.isEmpty {
                        innerLastOpenedNode.isClosed = true
                        nodes.append(innerLastOpenedNode)
                        lastOpenedNode = nil
                    } else {
                        // Exists previous not closed node
                        lastOpenedNode = nil
                        lastOpenedNode = nodes.first(where: { !$0.isClosed })
                        if let innerLastOpenedNode = lastOpenedNode, sourceString.index(sourceString.startIndex, offsetBy: index + closeResultMaxTokenCount) < sourceString.endIndex {
                            lastOpenedNode = .init(content: "", typeCandidates: innerLastOpenedNode.typeCandidates, parent: innerLastOpenedNode, children: [])
                            innerLastOpenedNode.children.append(lastOpenedNode!)
                        } else {
                            lastOpenedNode?.isClosed = true
                        }
                    }
                    index += closeResultMaxTokenCount
                }
            }
            let stringIndex = sourceString.index(sourceString.startIndex, offsetBy: index, limitedBy: sourceString.endIndex)
            if let stringIndex = stringIndex,
               index < sourceString.count,
               canOpenNewNode, let openResults = nodeTypesForOpenCharacter(as: stringIndex, in: sourceString, parent: nil) {
                
                let openResultMaxTokenCount = openResults.compactMap({ $0.token.token.count }).max() ?? 0
                
                let indexOfNewContent = sourceString.index(sourceString.startIndex, offsetBy: index + openResultMaxTokenCount, limitedBy: sourceString.index(before: sourceString.endIndex))
                if lastOpenedNode != nil, indexOfNewContent != nil {
                    let isInMainTree = lastOpenedNode?.typeCandidates.contains(.body) == true
                    let child: Node = .init(content: "", typeCandidates: openResults.compactMap { $0.nodeType }, parent: isInMainTree ? nil : lastOpenedNode, children: [])
                    if isInMainTree {
                        if let lastOpenedNode = lastOpenedNode {
                            lastOpenedNode.isClosed = true
                            nodes.append(lastOpenedNode)
                        }
                        nodes.append(child)
                    } else {
                        lastOpenedNode?.children.append(child)
                    }
                    lastOpenedNode = child
                    index += openResultMaxTokenCount
                    continue
                } else {
                    lastOpenedNode = .init(content: "", typeCandidates: openResults.compactMap { $0.nodeType }, parent: lastOpenedNode, children: [])
                    index += openResultMaxTokenCount
                    continue
                }
            }
            if let stringIndex = stringIndex,
               sourceString.indices.contains(stringIndex){
                let character = sourceString[stringIndex]
                let content: Substring = Substring(String(.init(unicodeScalarLiteral: sourceString[stringIndex])))
                if let lastOpenedNode = lastOpenedNode {
                    lastOpenedNode.content.append(character)
                } else {
                    lastOpenedNode = .init(content: content, typeCandidates: [.body], parent: nil, children: [])
                }
            }
            index += 1
            
        }
        
        if let lastOpenedNode = lastOpenedNode, lastOpenedNode.parent == nil, !nodes.contains(lastOpenedNode) {
            lastOpenedNode.isClosed = true
            nodes.append(lastOpenedNode)
        }
        return nodes
    }
    
    // MARK: - Private implementation
    
    private func nodeTypesForOpenCharacter(as index: Substring.Index, in sourceString: Substring, parent: Node?) -> [NodeFindResult]? {
        guard let nodeCandidates = sourceString[index].markdownNodeCandidates, !nodeCandidates.isEmpty else { return nil }
        let tokenCandidates = nodeCandidates.filter({ $0.tokenType == .open }).filter({ candidate in
            var isValidCandidate = true
            if let endIndex = sourceString.index(index, offsetBy: candidate.token.token.count - 1, limitedBy: sourceString.endIndex),
               sourceString.indices.contains(endIndex) {
                let substring = sourceString[index...endIndex]
                isValidCandidate = substring == Substring(candidate.token.token)
                
            } else {
                isValidCandidate = false
            }
            return isValidCandidate
        })
        return tokenCandidates.map {
            .init(nodeType: $0.subsectionType, token: $0.token, indexAfterNode: sourceString.index(index, offsetBy: $0.token.token.count))
        }
    }
    
    private func nodeTypesForCloseCharacter(as index: Substring.Index, in sourceString: Substring, parent: Node?) -> [NodeFindResult]? {
        guard let nodeCandidates = sourceString[index].markdownNodeCandidates, !nodeCandidates.isEmpty else { return nil }
        let tokenCandidates = nodeCandidates.filter({ $0.tokenType == .close }).filter({ candidate in
            var isValidCandidate = true
            if let endIndex = sourceString.index(index, offsetBy: candidate.token.token.count - 1, limitedBy: sourceString.index(before: sourceString.endIndex)),
               sourceString.indices.contains(endIndex) {
                let substring = sourceString[index...endIndex]
                isValidCandidate = substring == Substring(candidate.token.token)
                
            } else {
                isValidCandidate = false
            }
            return isValidCandidate
        })
        return tokenCandidates.map {
            .init(nodeType: $0.subsectionType, token: $0.token, indexAfterNode: sourceString.index(index, offsetBy: $0.token.token.count))
        }
    }
    
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
                    return .init(subsectionType: rule.type, tokenType: token.type, token: token, rule: rule)
                }
            })
            .compactMap({ $0 })
            .flatMap({ $0 })
    }
    
}

extension SubstringsNodeGenerator {
    
    final class Node: Equatable {
        
        static func == (lhs: SubstringsNodeGenerator.Node, rhs: SubstringsNodeGenerator.Node) -> Bool {
            lhs.content == rhs.content && lhs.typeCandidates == rhs.typeCandidates && lhs.parent == rhs.parent && lhs.isClosed == rhs.isClosed //&& lhs.children == rhs.children
        }
        
        /*
         Content of the tag without tag
         */
        var content: Substring
        var typeCandidates: [SubSectionType]
        var parent: Node?
        var children: [Node]
        var isClosed: Bool = false
        
        init(content: Substring,
             typeCandidates: [SubSectionType],
             parent: Node?,
             children: [Node],
             isClosed: Bool = false) {
            self.content = content
            self.typeCandidates = typeCandidates
            self.parent = parent
            self.children = children
            self.isClosed = isClosed
        }
        
        func closeParent(nodeTypes: [SubSectionType]) -> Bool {
            print("CloseParent: \(nodeTypes), my: \(typeCandidates)")
            if let candidate = typeCandidates.sorted(by: { ($0.openToken?.count ?? 0) > ($1.openToken?.count ?? 0) }).first(where: {
                nodeTypes.contains($0)
            }), !isClosed, !content.isEmpty {
                typeCandidates = [candidate]
//                closeChildrenAndAdjustContentIfNecessary()
                isClosed = true
                return true
            } else if let parent = parent {
                return parent.closeParent(nodeTypes: nodeTypes)
            } else {
                return false
            }
        }
        
        func closeChildrenAndAdjustContentIfNecessary() {
            children.forEach({ child in
                if !child.isClosed {
//                    child.content = (child.type.openToken ?? "") + child.content
                    child.isClosed = true
                }
//                child.closeChildrenAndAdjustContentIfNecessary()
            })
        }
    }
    
}

private extension SubSectionType {
    
    var openToken: String? {
        rule?.openToken.token
    }
    
}

