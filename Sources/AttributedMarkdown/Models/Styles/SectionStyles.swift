//
//  SectionStyles.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import Foundation
#if os(iOS)
import UIKit
#else
import AppKit
#endif

//var paragraphStyle: NSMutableParagraphStyle {
//    let style = NSMutableParagraphStyle()
//    switch self {
//    case .blockquote:
//        style.firstLineHeadIndent = 20
//        style.headIndent = 20
//    case .codeBlock,
//            .alternateCodeBlock:
//        style.firstLineHeadIndent = 20
//    case .unorderedList,
//            .orderedList:
//        style.tabStops = [NSTextTab(textAlignment: .left, location: 30, options: [:]), NSTextTab(textAlignment: .left, location: 30, options: [:])]
//        style.defaultTabInterval = 30
//        style.headIndent = 30
//    default: break
//    }
//    return style
//}

public struct SectionStyles {
    public var h1: Style
    public var h2: Style
    public var h3: Style
    public var h4: Style
    public var h5: Style
    public var h6: Style
    public var body: Style
    public var blockquote: Style
    public var codeBlock: Style
    public var unorderedList: Style
    public var orderedList: Style
    public var link: Style
    public var image: AttachmentStyle
    public var bold: Style
    public var italic: Style
    public var paragraph: Style
    
    public init(h1: Style = .init(font: .systemFont(ofSize: SectionType.h1.defaultFontSize)),
                h2: Style = .init(font: .systemFont(ofSize: SectionType.h2.defaultFontSize)),
                h3: Style = .init(font: .systemFont(ofSize: SectionType.h3.defaultFontSize)),
                h4: Style = .init(font: .systemFont(ofSize: SectionType.h4.defaultFontSize)),
                h5: Style = .init(font: .systemFont(ofSize: SectionType.h5.defaultFontSize)),
                h6: Style = .init(font: .systemFont(ofSize: SectionType.h6.defaultFontSize)),
                body: Style = .init(),
                blockquote: Style = .init(font: .systemFont(ofSize: SectionType.blockquote.defaultFontSize),
                                          paragraphStyle: {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.firstLineHeadIndent = 20
                        paragraphStyle.headIndent = 20
                        return paragraphStyle
                    }()
                ),
                codeBlock: Style = .init(font: .systemFont(ofSize: SectionType.codeBlock.defaultFontSize),
                                         paragraphStyle: {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.firstLineHeadIndent = 20
                        paragraphStyle.headIndent = 20
                        return paragraphStyle
                    }()
                ),
                unorderedList: Style = .init(),
                orderedList: Style = .init(),
                link: Style = .init(font: .systemFont(ofSize: SectionType.body.defaultFontSize), fontColor: .init(red: 122, green: 155, blue: 171, alpha: 1)),
                image: AttachmentStyle = .init(alignment: .center),
                bold: Style = .init(font: .boldSystemFont(ofSize: SectionType.bold.defaultFontSize)),
                italic: Style = .init(font: .systemFont(ofSize: SectionType.italic.defaultFontSize)),
                paragraph: Style = .init()
    ) {
        self.h1 = h1
        self.h2 = h2
        self.h3 = h3
        self.h4 = h4
        self.h5 = h5
        self.h6 = h6
        self.body = body
        self.blockquote = blockquote
        self.codeBlock = codeBlock
        self.unorderedList = unorderedList
        self.orderedList = orderedList
        self.link = link
        self.image = image
        self.bold = bold
        self.italic = italic
        self.paragraph = paragraph
    }
    
    #if os(iOS)
    public mutating func setForegroundColor(_ color: UIColor) {
        let stylsectionTypes = SectionType.allCases.filter({ $0 != .image })
        stylsectionTypes.forEach { sectionType in
            self[keyPath: property(for: sectionType)].fontColor = color
        }
    }
    #else
    public mutating func setForegroundColor(_ color: NSColor) {
        let stylsectionTypes = SectionType.allCases.filter({ $0 != .image })
        stylsectionTypes.forEach { sectionType in
            self[keyPath: property(for: sectionType)].fontColor = color
        }
    }
    #endif
    
    func sectionType(for style: AnyKeyPath) -> SectionType {
        switch style {
        case \Self.h1: return .h1
        case \Self.h2: return .h2
        case \Self.h3: return .h3
        case \Self.h4: return .h4
        case \Self.h5: return .h5
        case \Self.h6: return .h6
        case \Self.body: return .body
        case \Self.blockquote: return .blockquote
        case \Self.codeBlock: return .codeBlock
        case \Self.unorderedList: return .unorderedList
        case \Self.orderedList: return .orderedList
        case \Self.link: return .link
        case \Self.image: return .image
        case \Self.bold: return .bold
        case \Self.italic: return .italic
        case \Self.paragraph: return .paragraph
        default: return .body
        }
    }
    
    func property(for sectionType: SectionType) -> WritableKeyPath<SectionStyles, Style> {
        switch sectionType {
        case .h6:
            return \.h6
        case .h5:
            return \.h5
        case .h4:
            return \.h4
        case .h3:
            return \.h3
        case .h2:
            return \.h2
        case .h1:
            return \.h1
        case .body:
            return \.body
        case .blockquote:
            return \.blockquote
        case .codeBlock:
            return \.codeBlock
        case .unorderedList:
            return \.unorderedList
        case .orderedList:
            return \.orderedList
        case .bold:
            return \.bold
        case .italic:
            return \.italic
        case .image:
            fatalError("This type doesn't contain style")
        case .link:
            return \.link
        case .paragraph:
            return \.paragraph
        }
    }
    
}

