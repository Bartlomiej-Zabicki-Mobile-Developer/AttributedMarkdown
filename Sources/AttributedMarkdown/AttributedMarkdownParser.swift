import SwiftUI

public final class AttributedMarkdownParser {
    
    // MARK: - Properties
    
    private(set) var configuration: ParserConfiguration
    
    // MARK: - Initialization

    public init(configuration: ParserConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Functions
    
    func parse(markdown: String) async throws -> AttributedString {
        var attributedMarkdownResult: AttributedString = .init()
        let elements = retreiveSections(from: markdown)
        elements.forEach { element in
            let style = configuration.sectionStyles[keyPath: element.type.styleKeyPath]
            attributedMarkdownResult.append(element.asAttributedString(withStyle: style))
        }
        return attributedMarkdownResult
    }
    
    // MARK: - Private implementation
    
    private func retreiveSections(from source: String) -> [Section] {
        var sections: [Section] = []
        
        let contents = source.components(separatedBy: CharacterSet.newlines)
        
        for content in contents {
            guard let section = generateSection(from: content) else { continue }
            
            if section.influencesPreviousSection, var lastSection = sections.last {
                lastSection.changeSectionType(to: section.type)
                sections[sections.count - 1] = lastSection
                continue
            }
            sections.append(section)
        }
        
        return sections
    }
    
    private func generateSection(from content: String) -> Section? {
        for section in SectionType.allCases {
            guard let rule = section.rule, content.contains(rule.token) else { continue }
            var contentWithoutSectionRules = content
            switch rule.removeRule {
            case .leading:
                contentWithoutSectionRules = removeLeadingTokenIfPossible(from: content, token: rule.token)
            case .trailing:
                contentWithoutSectionRules = removeTrailingTokenIfPossible(from: content, token: rule.token)
            case .both:
                contentWithoutSectionRules = removeLeadingTokenIfPossible(from: content, token: rule.token)
                contentWithoutSectionRules = removeTrailingTokenIfPossible(from: contentWithoutSectionRules, token: rule.token)
            case .entireLine:
                let lineCandidate = content.replacingOccurrences(of: rule.token, with: "")
                if lineCandidate.isEmpty {
                    contentWithoutSectionRules = lineCandidate
                }
            }
            guard contentWithoutSectionRules != content else { continue }
            
            switch rule.type {
            case .unorderedList:
                contentWithoutSectionRules.insert(contentsOf: "・ ", at: contentWithoutSectionRules.startIndex)
            default: break
            }
            return Section(content: content, type: rule.type, influencesPreviousSection: rule.type.influencesPreviousLine)
        }
        
//        let previousSectionAttrubites = SectionType.allCases.filter({ $0.influencesPreviousLine })
//        for element in previousSectionAttrubites {
//            let output = content //(element.shouldTrim) ? inputLine.trimmingCharacters(in: .whitespaces) : inputLine
//            let charSet = CharacterSet(charactersIn: element.token)
//            if output.unicodeScalars.allSatisfy({ charSet.contains($0) }) {
//                return .init(content: "", type: .body, influencesPreviousSection: false)
//            }
//        }
        return Section(content: content.trimmingCharacters(in: .whitespaces),
                       type: .body,
                       influencesPreviousSection: false)
    }
    
    private func removeLeadingTokenIfPossible(from content: String, token: String) -> String {
        guard content.hasPrefix(token) else {
            return content
        }
        return content.replacingCharacters(in: content.startIndex..<token.endIndex, with: "")
    }
    
    private func removeTrailingTokenIfPossible(from content: String, token: String) -> String {
        guard content.hasSuffix(token) else {
            return content
        }
        return String(content[content.startIndex...content.index(content.startIndex,
                                                                 offsetBy: content.count - token.count)])
    }
    
}

extension Section {
    
    func asAttributedString(withStyle style: Style) -> AttributedString {
        var attrubutedString = AttributedString(content.appending("\n"))
        let container = AttributeContainer([
            .paragraphStyle: self.type.paragraphStyle
        ])
        attrubutedString.setAttributes(container)
        attrubutedString.backgroundColor = style.backgroundColor
        attrubutedString.foregroundColor = style.fontColor
        attrubutedString.font = style.font
        return attrubutedString
    }
    
}

extension SectionType {
    
    var paragraphStyle: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        switch self {
        case .blockquote:
            style.firstLineHeadIndent = 20
            style.headIndent = 20
        case .codeBlock,
                .alternateCodeBlock:
            style.firstLineHeadIndent = 20
        case .unorderedList,
                .orderedList:
            style.tabStops = [NSTextTab(textAlignment: .left, location: 30, options: [:]), NSTextTab(textAlignment: .left, location: 30, options: [:])]
            style.defaultTabInterval = 30
            style.headIndent = 30
        default: break
        }
        return style
    }
}
