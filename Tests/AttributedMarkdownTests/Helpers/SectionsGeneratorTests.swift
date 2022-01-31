//
//  SectionsGeneratorTests.swift
//  
//
//  Created by Bart on 31/01/2022.
//

import XCTest
@testable import AttributedMarkdown

final class SectionsGeneratorTests: XCTestCase {
    
    var sectionsGenerator: SectionsGenerator!
    
    override func setUp() {
        super.setUp()
        sectionsGenerator = SectionsGeneratorImpl()
    }
    
    // MARK: - SingleBlock
    
    func testSingleAlternateH1Block() async throws {
        let rawString = """
                        Test
                        =====
                        """
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .alternateH1, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleAlternateH2Block() async throws {
        let rawString = """
                        Test
                        ----
                        """
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .alternateH2, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleH1Block() async throws {
        let rawString = "#Test#"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .h1, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleH2Block() async throws {
        let rawString = "##Test##"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .h2, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleH3Block() async throws {
        let rawString = "###Test###"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .h3, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleH4Block() async throws {
        let rawString = "####Test####"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .h4, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleH5Block() async throws {
        let rawString = "#####Test#####"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .h5, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleH6Block() async throws {
        let rawString = "######Test######"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .h6, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleBlockquoteBlock() async throws {
        let rawString = ">Test"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .blockquote, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleCodeBlock() async throws {
        let rawString = "    Test"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .codeBlock, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleAlternateCodeBlock() async throws {
        let rawString = "\tTest"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "Test", type: .codeBlock, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleUnorderedListBlock() async throws {
        let rawString = "* Test"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "・ Test", type: .unorderedList, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
    func testSingleOrderedListBlock() async throws {
        let rawString = "1. Test"
        let sections = await sectionsGenerator.retrieveSections(from: rawString)
        
        let expectedSections: [Section] = [.init(content: "1. Test", type: .orderedList, influencesPreviousSection: false)]
        
        XCTAssertEqual(sections, expectedSections)
    }
    
}
