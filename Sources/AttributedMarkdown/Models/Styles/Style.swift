//
//  Style.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import Foundation
import SwiftUI

public enum Alignment {
    case leading
    case trailing
    case center
}


#if os(iOS)
public struct Style {
    let font: Font
    let fontColor: Color
    private(set) var backgroundColor: Color = .clear
    private(set) var alignment: Alignment = .leading
    private(set) var paragraphStyle: NSMutableParagraphStyle = .init()
    
    static let body: Style = .init(font: .systemFont(ofSize: SectionType.body.defaultFontSize),
                                   fontColor: .white,
                                   backgroundColor: .clear,
                                   alignment: .leading,
                                   paragraphStyle: .init())
}
#endif

#if os(macOS)
public struct Style {
    let font: NSFont
    let fontColor: NSColor
    private(set) var backgroundColor: NSColor = .clear
    private(set) var alignment: Alignment = .leading
    private(set) var paragraphStyle: NSMutableParagraphStyle = .init()
    
    static let body: Style = .init(font: .systemFont(ofSize: SectionType.body.defaultFontSize),
                                   fontColor: .white,
                                   backgroundColor: .clear,
                                   alignment: .leading,
                                   paragraphStyle: .init())
}
#endif
