//
//  AttributedMarkdownParserTests.swift
//  
//
//  Created by Bart on 23/01/2022.
//

import XCTest
@testable import AttributedMarkdown

final class AttributedMarkdownParserTests: XCTestCase {
    
    var attributedMarkdownParser: AttributedMarkdownParser?
    
    override func setUp() {
        super.setUp()
        attributedMarkdownParser = .init(configuration: .default)
    }
    
    func testSingleHeaderBlock() async throws {
        let rawString = "# Test"
        let attributedString = try await attributedMarkdownParser?.parse(markdown: rawString)
        
        var expectedAttributedString = AttributedString("Test\n")
        expectedAttributedString.backgroundColor = .clear
        expectedAttributedString.foregroundColor = .white
        expectedAttributedString.font = .title
//        expectedAttributedString.paragraphStyle = .init()
        
        XCTAssertEqual(attributedString, expectedAttributedString)
    }
    
    func testBoldAndItalic() async throws {
        let rawString = "***test**italic*"
        let attributedString = try await attributedMarkdownParser?.parse(markdown: rawString)
        
        var expectedAttributedStringBold = AttributedString("test")
        expectedAttributedStringBold.backgroundColor = .clear
        expectedAttributedStringBold.foregroundColor = .white
        expectedAttributedStringBold.font = .body.bold()
        
        var expectedAttributedStringItalic = AttributedString("italic")
        expectedAttributedStringItalic.backgroundColor = .clear
        expectedAttributedStringItalic.foregroundColor = .white
        expectedAttributedStringItalic.font = .body.italic()
        
        let expectedAttributedString = expectedAttributedStringBold + expectedAttributedStringItalic
        
        XCTAssertEqual(attributedString, expectedAttributedString)
    }
    
}
