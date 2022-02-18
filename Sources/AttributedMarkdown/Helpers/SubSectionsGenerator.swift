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

final class SubSectionsGeneratorImpl: SubSectionsGenerator {
    
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
        
        let separateSubsections = separateLinesAndWhitespaces.compactMap({ value -> [SubSection] in
            var subSections: [SubSection] = []
//            var tokensRanges: [ClosedRange<String.Index>] = []
            ///For each subsection that have rules generating subsection
            SubSectionType.allCases
                .filter({ $0.rule != nil })
                .forEach { type in
                    if let subSectionRange = range(of: type.rule!, in: Substring(modifiedContent)) {
                        let content = modifiedContent[subSectionRange.range]
                        let subSection = SubSection(content: String(content), type: type)
                        subSections.append(subSection)
//                        tokensRanges.append(contentsOf: subSectionRange.tokensRanges)
                        modifiedContent = subSectionRange.modifiedContent
                    }
            }
            
            // Fill up
            
            return subSections
        })
        return separateSubsections.flatMap({ $0 })
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
                         modifiedContent: String(modifiedContent))
        }
        ///Check sourceString contains closeToken after openToken
        modifiedContent.replaceSubrange(openRange, with: "")
        if let closeRange = modifiedContent
//               .replacingOccurrences(of: subSectionRule.openToken.token, with: "", options: [], range: nil)
               .range(of: closeToken.token) {
            
            let closeTokenStartIndex = sourceString.index(closeRange.lowerBound, offsetBy: .init(closeToken.token.count))
            let closeTokenCloseRangeIndex = sourceString.index(closeRange.lowerBound, offsetBy: .init(closeToken.token.count + 1))
            
            let openTokenEndIndex = sourceString.index(openRange.lowerBound, offsetBy: .init(subSectionRule.openToken.token.count))
            
            let range = openRange.lowerBound...closeTokenCloseRangeIndex
            
            let modifiedContent = String(sourceString[range])
            
            return .init(range: range,
                         tokensRanges: [openRange.lowerBound...openTokenEndIndex,
                                        closeTokenStartIndex...closeTokenCloseRangeIndex],
                         modifiedContent: modifiedContent)
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
