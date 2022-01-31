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
        let rawString = """
                        Test
                        =====
                        """
        let attributedString = try await attributedMarkdownParser?.parse(markdown: rawString)
        
        var expectedAttributedString = AttributedString("Test\n")
        expectedAttributedString.backgroundColor = .clear
        expectedAttributedString.foregroundColor = .white
        expectedAttributedString.font = .title
        expectedAttributedString.paragraphStyle = .init()
        
        XCTAssertEqual(attributedString, expectedAttributedString)
    }
    
}
