//
//  SubSectionsGeneratorTests.swift
//  
//
//  Created by Bart on 06/02/2022.
//

import XCTest
@testable import AttributedMarkdown

class SubSectionsGeneratorTests: XCTestCase {
    
    var subSectionsGenerator: SubSectionsGenerator!
    
    override func setUp() {
        super.setUp()
        subSectionsGenerator = SubSectionsGeneratorImpl()
    }
    
    // MARK: - SingleBlock
    
    func testBoldSubsection() async throws {
        let rawString = "not bolded **bolded**"
        let section = Section(content: rawString, type: .body, influencesPreviousSection: false)
        let sections = await subSectionsGenerator.parse(section: section)
        
        let expectedSubSections: [SubSection] = [.init(content: "not bolded", type: .body),
                                                 .init(content: "bolded", type: .bold)]
        
        XCTAssertEqual(sections, expectedSubSections)
    }
    
    func testItalicSubsection() async throws {
        let rawString = "not italic *italic*"
        let section = Section(content: rawString, type: .body, influencesPreviousSection: false)
        let sections = await subSectionsGenerator.parse(section: section)
        
        let expectedSubSections: [SubSection] = [.init(content: "not italic", type: .body),
                                                 .init(content: "italic", type: .italic)]
        
        XCTAssertEqual(sections, expectedSubSections)
    }
    
    func testBoldedAndNonItalicSubsection() async throws {
        let rawString = "Something ***Bolded**Nonbolded*"
        let section = Section(content: rawString, type: .body, influencesPreviousSection: false)
        let sections = await subSectionsGenerator.parse(section: section)
        
        let expectedSubSections: [SubSection] = [.init(content: "Something", type: .body),
                                                 .init(content: "*Bolded", type: .bold),
                                                 .init(content: "Nonbolded*", type: .body)]
        
        XCTAssertEqual(sections, expectedSubSections)
    }

}
