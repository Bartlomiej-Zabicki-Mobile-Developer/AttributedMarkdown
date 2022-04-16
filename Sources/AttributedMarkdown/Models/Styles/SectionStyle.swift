//
//  Style.swift
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

public enum Alignment {
    case leading
    case trailing
    case center
}


#if os(iOS)
public struct Style {
    let font: UIFont
    var fontColor: UIColor
    ///If paragraphStyle provided, it overwrites alignment parameter
    let alignment: Alignment
    ///If provided, overwrites alignment parameter
    let paragraphStyle: NSMutableParagraphStyle
    
    public init(font: UIFont = .systemFont(ofSize: SectionType.body.defaultFontSize),
                fontColor: UIColor = .lightGray,
                alignment: Alignment = .leading,
                paragraphStyle: NSMutableParagraphStyle = .init()) {
        self.font = font
        self.fontColor = fontColor
        self.alignment = alignment
        self.paragraphStyle = paragraphStyle
    }
}
#endif

#if os(macOS)
public struct Style {
    let font: NSFont
    var fontColor: NSColor
    ///If paragraphStyle provided, it overwrites alignment parameter
    let alignment: Alignment
    ///If provided, overwrites alignment parameter
    let paragraphStyle: NSMutableParagraphStyle
    
    public init(font: NSFont = .systemFont(ofSize: SectionType.body.defaultFontSize),
                fontColor: NSColor = .lightGray,
                alignment: Alignment = .leading,
                paragraphStyle: NSMutableParagraphStyle = .init()) {
        self.font = font
        self.fontColor = fontColor
        self.alignment = alignment
        self.paragraphStyle = paragraphStyle
    }
}
#endif
