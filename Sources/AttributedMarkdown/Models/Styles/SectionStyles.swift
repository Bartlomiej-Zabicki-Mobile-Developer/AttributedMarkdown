//
//  SectionStyles.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import Foundation

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
    var h1: Style = .init(font: .title, fontColor: .white, backgroundColor: .clear, alignment: .leading)
    var h2: Style = .init(font: .title2, fontColor: .white, backgroundColor: .clear, alignment: .leading)
    var h3: Style = .init(font: .title3, fontColor: .white, backgroundColor: .clear, alignment: .leading)
    var h4: Style = .init(font: .caption, fontColor: .white, backgroundColor: .clear, alignment: .leading)
    var h5: Style = .init(font: .caption2, fontColor: .white, backgroundColor: .clear, alignment: .leading)
    var h6: Style = .init(font: .subheadline, fontColor: .white, backgroundColor: .clear, alignment: .leading)
    var body: Style = .body
    var blockquote: Style = .init(font: .body, fontColor: .red, backgroundColor: .white, alignment: .leading, paragraphStyle: .init())
    var codeBlock: Style = .init(font: .body.italic(), fontColor: .yellow, backgroundColor: .clear, alignment: .leading)
    var unorderedList: Style = .body
    var orderedList: Style = .body
    var link: Style = .init(font: .body, fontColor: .blue, backgroundColor: .white, alignment: .leading, paragraphStyle: .init())
    var image: AttachmentStyle = .init(alignment: .center)
    var bold: Style = .init(font: .body.bold(), fontColor: .white, backgroundColor: .clear, alignment: .leading)
    var italic: Style = .init(font: .body.italic(), fontColor: .white, backgroundColor: .clear, alignment: .leading)
    var paragraph: Style = .body
    
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
}

