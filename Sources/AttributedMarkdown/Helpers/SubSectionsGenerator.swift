//
//  SubSectionsGenerator.swift
//  
//
//  Created by Bart on 03/02/2022.
//

import Foundation

protocol SubSectionsGenerator {
    func parse(section: Section) -> [SubSection]
}

extension SubSectionType {
    
    init(from source: SubSectionsGeneratorImpl.Node.NodeType) {
        switch source {
        case .body:
            self = .body
        case .link:
            self = .link
        case .italic:
            self = .italic
        case .bold:
            self = .bold
        case .image:
            self = .image
        }
    }
}

/*
 Generates node structure
 1. Goes through all lines inside
 2. Inside line it generate nodes with given styles
 3. Nodes should be joined from the bottom up
 4. Each node has range from the parent so the uppernode now which subrange replace
 5. Siblings can be just joined together
 */
final class SubSectionsGeneratorImpl: SubSectionsGenerator {
    
    struct Node {
        
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
        let content: String
        let type: NodeType
        let range: ClosedRange<String.Index>
        let subNodes: [Node]
    }
    
    struct SubSectionFound {
        let range: ClosedRange<String.Index>
        let tokensRanges: [ClosedRange<String.Index>]
        let content: String
    }
    
    func parse(section: Section) -> [SubSection] {
        let separateLinesAndWhitespaces = section.content.split { character in
            character.isNewline || character.isWhitespace
        }
        
//        SubSectionType.allCases.forEach { subSectionType in
//            separateLinesAndWhitespaces.
//        }
        var modifiedContent = section.content
        var separateSubsections: [SubSection] = []
        
        var nodes: [Node] = separateLinesAndWhitespaces.compactMap { substring in
            subsectionNodes(in: substring)
        }
        
        nodes.forEach({ node in
            guard var lastSubsection = separateSubsections.last else {
                separateSubsections.append(.init(content: node.content, type: .init(from: node.type)))
                return
            }
            if lastSubsection.type == .init(from: node.type) {
                separateSubsections[separateSubsections.count - 1] = .init(content: [lastSubsection.content, node.content].joined(separator: " "), type: .init(from: node.type))
            } else {
                separateSubsections.append(.init(content: node.content, type: .init(from: node.type)))
            }
        })
        
        print("Nodes")
        return separateSubsections
    }
    
    private func subsectionNodes(in content: Substring) -> Node {
        var node: Node?
        SubSectionType.allCases
            .filter({ $0.rule != nil })
            .forEach({ subsectionType in
                guard node == nil, let subSectionRange = range(of: subsectionType.rule!, in: content) else {
                    return
                }
                let nodeContent = content[subSectionRange.range]
                let subNodes: [Node] = [subsectionNodes(in: nodeContent)].filter({ $0.type != .body })
                node = .init(content: subSectionRange.content, type: .init(from: subsectionType), range: subSectionRange.range, subNodes: subNodes)
            })
        
        let stringContent = String(content)
        if let node = node {
            return node
        } else {
            return .init(content: stringContent, type: .body, range: stringContent.startIndex...stringContent.endIndex, subNodes: [])
        }
//        let flattenNodes = nodes.flatMap({ $0 })
//        let stringContent = String(content)
//        if !flattenNodes.isEmpty {
//            return flattenNodes
//        } else {
//            return [.init(content: .init(content), type: .body, range: stringContent.startIndex...stringContent.endIndex, subNodes: [])]
//        }
    }
    
    // MARK: - Private implementation
    
    private func range(of subSectionRule: SubSectionRule, in sourceString: Substring) -> SubSectionFound? {
        ///Check if string contains openToken
        guard let openRange = sourceString.range(of: subSectionRule.openToken.token) else { return nil }
        var modifiedContent = sourceString
        ///Check if subsection needs close tag, if not range beginning with open tag is returned
        guard let closeToken = subSectionRule.otherTokens.first(where: { $0.type == .close }) else {
            let range = openRange.lowerBound...sourceString.endIndex
            let openTokenCount = subSectionRule.openToken.token.endIndex
            modifiedContent.removeSubrange(openRange)
            print("Content: \(modifiedContent)")
            
            return .init(range: range,
                         tokensRanges: [openRange.lowerBound...openTokenCount],
                         content: String(modifiedContent))
        }
        ///Check sourceString contains closeToken after openToken
        modifiedContent.replaceSubrange(openRange, with: "")
        if let closeRange = modifiedContent
//               .replacingOccurrences(of: subSectionRule.openToken.token, with: "", options: [], range: nil)
               .range(of: closeToken.token) {
            
            let closeTokenCloseRangeIndex = sourceString.index(closeRange.upperBound, offsetBy: -1)
            
            let openTokenEndIndex = sourceString.index(openRange.lowerBound, offsetBy: .init(subSectionRule.openToken.token.count))
            
            let range = openRange.upperBound...closeTokenCloseRangeIndex
            
            let modifiedContent = String(sourceString[range])
            
            return .init(range: range,
                         tokensRanges: [openRange.lowerBound...openTokenEndIndex,
                                        closeRange.lowerBound...closeRange.upperBound],
                         content: modifiedContent)
        }
        ///sourceString contains openToken but doesn't contain closeToken
        return nil
    }
    
}

private extension Character {
    
//    var isNewLine: Bool {
//        CharacterSet.newlines.contains(self)
//    }
    
//    var isSpace: Bool {
//        CharacterSet.whitespaces.contains(self)
//    }
    
}
