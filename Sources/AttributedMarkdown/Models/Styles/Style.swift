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
    let backgroundColor: Color
    let alignment: Alignment
    let type: SectionType
    
    static let body: Style = .init(font: .body, fontColor: .white, backgroundColor: .clear, alignment: .leading, type: .body)
}
