//
//  Section.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import Foundation

struct Section: Equatable {
    let content: String
    private(set) var type: SectionType
    let influencesPreviousSection: Bool
    
    mutating func changeSectionType(to newSectionType: SectionType) {
        type = newSectionType
    }
    
}
