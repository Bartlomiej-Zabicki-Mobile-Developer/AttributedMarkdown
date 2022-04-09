import SwiftUI
import Markdown

public final class AttributedMarkdownParser {
    
    // MARK: - Properties
    
    private(set) var configuration: ParserConfiguration
    
    // MARK: - Initialization

    public init(configuration: ParserConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Functions
    
    public func parse(markdown: String) async throws -> AttributedString {
        let document = Document(parsing: markdown)
        var visitor = AttributedStringVisitor(styles: configuration.sectionStyles)
        let newDocument = visitor.visit(document)
        return newDocument
    }
    
}
