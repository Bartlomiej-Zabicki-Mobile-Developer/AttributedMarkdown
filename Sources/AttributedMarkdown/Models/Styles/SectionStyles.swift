//
//  SectionStyles.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import Foundation

public struct SectionStyles {
    var h1: Style = .init(font: .title, fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .h1)
    var h2: Style = .init(font: .title2, fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .h2)
    var h3: Style = .init(font: .title3, fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .h3)
    var h4: Style = .init(font: .caption, fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .h4)
    var h5: Style = .init(font: .caption2, fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .h5)
    var h6: Style = .init(font: .subheadline, fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .h6)
    var body: Style = .body
    var blockquote: Style = .body
    var codeBlock: Style = .init(font: .body.italic(), fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .codeBlock)
    var unorderedList: Style = .body
    var orderedList: Style = .body
    var link: Style = .body
    var image: AttachmentStyle = .init(alignment: .center)
    var bold: Style = .init(font: .body.bold(), fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .body)
    var italic: Style = .init(font: .body.italic(), fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .body)
}
