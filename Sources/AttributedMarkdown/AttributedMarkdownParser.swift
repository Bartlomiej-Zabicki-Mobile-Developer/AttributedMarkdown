import SwiftUI

public final class AttributedMarkdownParser {
    
    // MARK: - Properties
    
    private(set) var configuration: ParserConfiguration
    private lazy var sectionsGenerator: SectionsGenerator = SectionsGeneratorImpl()
    
    // MARK: - Initialization

    public init(configuration: ParserConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Functions
    
    func parse(markdown: String) async throws -> AttributedString {
        var attributedMarkdownResult: AttributedString = .init()
        let elements = await sectionsGenerator.retrieveSections(from: markdown)
        elements.forEach { element in
            let style = configuration.sectionStyles[keyPath: element.type.styleKeyPath]
            attributedMarkdownResult.append(element.asAttributedString(withStyle: style))
        }
        return attributedMarkdownResult
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
