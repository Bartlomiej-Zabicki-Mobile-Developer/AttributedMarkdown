//
//  SubstringsNodesGeneratorTests.swift
//  
//
//  Created by Bart on 21/02/2022.
//

import XCTest
@testable import AttributedMarkdown

class SubstringsNodesGeneratorTests: XCTestCase {
    
    var substringsNodeGenerator: SubstringsNodeGenerator!
    
    override func setUp() {
        super.setUp()
        substringsNodeGenerator = SubstringsNodeGenerator()
    }
    
    // MARK: - SingleBlock
    
    func testBoldSubsection() async throws {
        let rawString: Substring = "not bolded **bolded**"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)
        
        let expectedNodes = [Node(content: "not bolded ", type: .body, rangeInOrigin: ClosedRange(range: 0...10, in: rawString), children: []),
                               Node(content: "bolded", type: .bold, rangeInOrigin: ClosedRange(range: 11...20, in: rawString), children: [])]
        
        XCTAssertEqual(nodes, expectedNodes)
    }
    
    func testItalicSubsectionInMiddle() async throws {
        let rawString: Substring = "t *italic* not italic"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)
        
        let expectedNodes = [Node(content: "t ", type: .body, rangeInOrigin: ClosedRange(range: 0...1, in: rawString), children: []),
                             Node(content: "italic", type: .italic, rangeInOrigin: ClosedRange(range: 2...9, in: rawString), children: []),
                             Node(content: " not italic", type: .body, rangeInOrigin: ClosedRange(range: 10...20, in: rawString), children: [])]
        
        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
        XCTAssertEqual(nodes.compactMap { $0.rangeInOrigin }, expectedNodes.compactMap { $0.rangeInOrigin })
        XCTAssertEqual(nodes, expectedNodes)
    }
    
    func testItalicSubsectionOnStart() async throws {
        let rawString: Substring = "*italic* not italic"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)
        
        let expectedNodes = [Node(content: "italic", type: .italic, rangeInOrigin: ClosedRange(range: 0...7, in: rawString), children: []),
                             Node(content: " not italic", type: .body, rangeInOrigin: ClosedRange(range: 8...18, in: rawString), children: [])]
        
        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
        XCTAssertEqual(nodes.compactMap { $0.rangeInOrigin }, expectedNodes.compactMap { $0.rangeInOrigin })
        XCTAssertEqual(nodes, expectedNodes)
    }
    
//    func testItalicSubsection() async throws {
//        let rawString = "not italic *italic*"
//        let section = Section(content: rawString, type: .body, influencesPreviousSection: false)
//        let sections = await subSectionsGenerator.parse(section: section)
//
//        let expectedSubSections: [SubSection] = [.init(content: "not italic", type: .body),
//                                                 .init(content: "italic", type: .italic)]
//
//        XCTAssertEqual(sections, expectedSubSections)
//    }
//
//    func testBoldedAndNonItalicSubsection() async throws {
//        let rawString = "Something ***Bolded**Nonbolded*"
//        let section = Section(content: rawString, type: .body, influencesPreviousSection: false)
//        let sections = await subSectionsGenerator.parse(section: section)
//
//        let expectedSubSections: [SubSection] = [.init(content: "Something", type: .body),
//                                                 .init(content: "*Bolded", type: .bold),
//                                                 .init(content: "Nonbolded*", type: .body)]
//
//        XCTAssertEqual(sections, expectedSubSections)
//    }
//
//    func testItalicInsideBoldSubsection() async throws {
//        let rawString = "Something **Bolded *italic***"
//        let section = Section(content: rawString, type: .body, influencesPreviousSection: false)
//        let sections = await subSectionsGenerator.parse(section: section)
//
//        let expectedSubSections: [SubSection] = [.init(content: "Something", type: .body),
//                                                 .init(content: "Bolded", type: .bold),
//                                                 .init(content: "italic", type: .italic)]
//
//        XCTAssertEqual(sections, expectedSubSections)
//    }

}

extension ClosedRange where Bound == String.Index {
    
    init(range inputRange: ClosedRange<Int>, in source: Substring) {
        let startIndex = source.index(source.startIndex, offsetBy: inputRange.lowerBound, limitedBy: source.endIndex)!
        let endIndex = source.index(source.startIndex, offsetBy: inputRange.upperBound, limitedBy: source.endIndex)!
        self = startIndex...endIndex
    }
    
}
