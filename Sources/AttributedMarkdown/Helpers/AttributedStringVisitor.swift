//
//  AttributedStringVisitor.swift
//  
//
//  Created by Bart on 09/04/2022.
//

import Markdown
import SwiftUI

struct AttributedStringVisitor: MarkupVisitor {
    
    typealias Result = AttributedString
    
    // MARK: - Properties
    
    private let styles: SectionStyles
    
    // MARK: - Initialization
    
    init(styles: SectionStyles) {
        self.styles = styles
    }
    
    // MARK: - MarkupVisitor
    
    func defaultVisit(_ markup: Markup) -> AttributedString {
        return formatted(string: markup.format(), forMarkup: markup.parent)
    }
    
    func formatted(string: String, forMarkup markup: Markup?) -> AttributedString {
        guard let markup = markup else {
            return .init()
        }
        let keyPath = styleFor(markup: markup)
        return string.asAttributedString(withStyle: keyPath, in: styles)
    }
    
    public mutating func visit(_ markup: Markup) -> Result {
        let newChildren = markup.children.compactMap { child -> AttributedString in
            if child is Markdown.Text {
                return child.accept(&self)
            } else {
                return visit(child)
            }
        }
        
        return newChildren.reduce(into: AttributedString()) { partialResult, attributed in
            partialResult.append(attributed)
        }
    }
    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> Result {
        return defaultVisit(blockQuote)
    }
    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Result {
        return defaultVisit(codeBlock)
    }
    public mutating func visitCustomBlock(_ customBlock: CustomBlock) -> Result {
        return defaultVisit(customBlock)
    }
    public mutating func visitDocument(_ document: Document) -> Result {
        return defaultVisit(document)
    }
    public mutating func visitHeading(_ heading: Heading) -> Result {
        return defaultVisit(heading)
    }
    public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Result {
        return defaultVisit(thematicBreak)
    }
    public mutating func visitHTMLBlock(_ html: HTMLBlock) -> Result {
        return defaultVisit(html)
    }
    public mutating func visitListItem(_ listItem: ListItem) -> Result {
        return defaultVisit(listItem)
    }
    public mutating func visitOrderedList(_ orderedList: OrderedList) -> Result {
        return defaultVisit(orderedList)
    }
    public mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> Result {
        return defaultVisit(unorderedList)
    }
    public mutating func visitParagraph(_ paragraph: Paragraph) -> Result {
        return defaultVisit(paragraph)
    }
    public mutating func visitBlockDirective(_ blockDirective: BlockDirective) -> Result {
        return defaultVisit(blockDirective)
    }
    public mutating func visitInlineCode(_ inlineCode: InlineCode) -> Result {
        return defaultVisit(inlineCode)
    }
    public mutating func visitCustomInline(_ customInline: CustomInline) -> Result {
        return defaultVisit(customInline)
    }
    public mutating func visitEmphasis(_ emphasis: Emphasis) -> Result {
        return defaultVisit(emphasis)
    }
    public mutating func visitImage(_ image: Markdown.Image) -> Result {
        return defaultVisit(image)
    }
    public mutating func visitInlineHTML(_ inlineHTML: InlineHTML) -> Result {
        return defaultVisit(inlineHTML)
    }
    public mutating func visitLineBreak(_ lineBreak: LineBreak) -> Result {
        return defaultVisit(lineBreak)
    }
    public mutating func visitLink(_ link: Markdown.Link) -> Result {
        return defaultVisit(link)
    }
    public mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Result {
        return defaultVisit(softBreak)
    }
    public mutating func visitStrong(_ strong: Strong) -> Result {
        return defaultVisit(strong)
    }
    public mutating func visitText(_ text: Markdown.Text) -> Result {
        return defaultVisit(text)
    }
    public mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> Result {
        return defaultVisit(strikethrough)
    }
    public mutating func visitTable(_ table: Markdown.Table) -> Result {
        return defaultVisit(table)
    }
    public mutating func visitTableHead(_ tableHead: Markdown.Table.Head) -> Result {
        return defaultVisit(tableHead)
    }
    public mutating func visitTableBody(_ tableBody: Markdown.Table.Body) -> Result {
        return defaultVisit(tableBody)
    }
    public mutating func visitTableRow(_ tableRow: Markdown.Table.Row) -> Result {
        return defaultVisit(tableRow)
    }
    public mutating func visitTableCell(_ tableCell: Markdown.Table.Cell) -> Result {
        return defaultVisit(tableCell)
    }
    public mutating func visitSymbolLink(_ symbolLink: SymbolLink) -> Result {
        return defaultVisit(symbolLink)
    }
    
    // MARK: - Private implementation
    
    private func styleFor(markup: Markup) -> AnyKeyPath {
        switch markup {
        case is Heading:
            return \SectionStyles.h1
        case is Strong:
            return \SectionStyles.bold
        case is Emphasis:
            return \SectionStyles.italic
        case is Markdown.Link:
            return \SectionStyles.link
        case is Markdown.BlockQuote:
            return \SectionStyles.blockquote
        default:
            return \SectionStyles.body
        }
    }
    
}

extension String {
    
    func asAttributedString(withStyle styleKeyPath: AnyKeyPath, in styles: SectionStyles) -> AttributedString {
        let style = styles[keyPath: styleKeyPath] as! Style
        let rawSource = styles.sectionType(for: styleKeyPath).isInLine ? self : self.appending("\n")
        var attrubutedString = AttributedString(rawSource)
        let container = AttributeContainer([
            .paragraphStyle: style.paragraphStyle
        ])
        attrubutedString.setAttributes(container)
        attrubutedString.backgroundColor = style.backgroundColor
        attrubutedString.foregroundColor = style.fontColor
        attrubutedString.font = style.font
        
        return attrubutedString
    }
    
}
