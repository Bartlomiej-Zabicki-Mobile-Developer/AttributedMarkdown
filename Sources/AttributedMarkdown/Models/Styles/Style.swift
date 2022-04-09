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

public struct Style {
    let font: Font
    let fontColor: Color
    private(set) var backgroundColor: Color = .clear
    private(set) var alignment: Alignment = .leading
    private(set) var paragraphStyle: NSMutableParagraphStyle = .init()
    
    static let body: Style = .init(font: .body, fontColor: .white, backgroundColor: .clear, alignment: .leading, paragraphStyle: .init())
}
