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
        return formatted(content: markup.format(), markupStyle: markup.parent ?? markup)
    }
    
    func formatted(content: String, markupStyle: Markup) -> AttributedString {
        let keyPath = styleFor(markup: markupStyle)
        return asAttributedString(content: content, style: styles[keyPath: keyPath] as! Style, andParent: markupStyle)
    }
    
    public mutating func visit(_ markup: Markup) -> Result {
        if markup.childCount > 0 {
            let newChildren = markup.children.compactMap { child -> AttributedString in
                if child is Markdown.Text {
                    let newChild = child.accept(&self)
                    return newChild
                } else {
                    return visit(child)
                }
            }
            
            var newResult = newChildren.reduce(into: AttributedString()) { partialResult, attributed in
                partialResult.append(attributed)
            }
            if markup.parent?.isIdentical(to: markup.root) == true {
                return newResult + .init("\n")
            }
            return newResult
        } else {
            return markup.accept(&self)
        }
    }
    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> Result {
        return defaultVisit(blockQuote)
    }
    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Result {
        return formatted(content: codeBlock.code, markupStyle: codeBlock)
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
        return formatted(content: link.plainText, markupStyle: link)
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
    
    private func asAttributedString(content: String,
                                    style: Style,
                                    andParent parent: Markup) -> AttributedString {
        let rawSource = content
        var attrubutedString = AttributedString(rawSource)
        let container = AttributeContainer([
            .paragraphStyle: style.paragraphStyle
        ])
        attrubutedString.setAttributes(container)
        if let link = parent as? Markdown.Link, let destination = link.destination {
            attrubutedString.link = .init(string: destination)
        }
        attrubutedString.backgroundColor = style.backgroundColor
        attrubutedString.foregroundColor = style.fontColor
        attrubutedString.font = style.font
        
        return attrubutedString
    }
    
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
        case is Paragraph:
            return \SectionStyles.paragraph
        case is CodeBlock:
            return \SectionStyles.codeBlock
        default:
            return \SectionStyles.body
        }
    }
    
}
