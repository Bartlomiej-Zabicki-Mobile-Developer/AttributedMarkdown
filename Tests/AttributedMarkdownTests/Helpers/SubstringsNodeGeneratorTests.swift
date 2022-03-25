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
    
    func testBoldy() async throws {
        let rawString: Substring = "not bolded "
        let nodes = substringsNodeGenerator.findNodes(in: rawString)
        
        let expectedNodes = [Node(content: "not bolded ", type: .body, parent: nil, children: [], isClosed: false)]
        
        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
        XCTAssertEqual(nodes, expectedNodes)
    }
    
    func testBoldSubsectionOnEnd() async throws {
        let rawString: Substring = "not bolded **bolded**"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)

        let expectedNodes = [Node(content: "not bolded ", type: .body, parent: nil, children: [], isClosed: false),
                             Node(content: "bolded", type: .bold, parent: nil, children: [], isClosed: true)]

        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
        XCTAssertEqual(nodes, expectedNodes)
    }
//
//    func testBoldSubsectionOnBeginning() async throws {
//        let rawString: Substring = "**bolded** not bolded "
//        let nodes = substringsNodeGenerator.findNodes(in: rawString)
//
//        let expectedNodes = [Node(content: "bolded", type: .bold, rangeInOrigin: ClosedRange(range: 0...9, in: rawString), children: []),
//                             Node(content: " not bolded ", type: .body, rangeInOrigin: ClosedRange(range: 10...21, in: rawString), children: [])]
//
//        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
//        XCTAssertEqual(nodes, expectedNodes)
//    }
//
//    func testBoldSubsectionInMiddle() async throws {
//        let rawString: Substring = "not **bolded** bolded"
//        let nodes = substringsNodeGenerator.findNodes(in: rawString)
//
//        let expectedNodes = [Node(content: "not ", type: .body, rangeInOrigin: ClosedRange(range: 0...3, in: rawString), children: []),
//                             Node(content: "bolded", type: .bold, rangeInOrigin: ClosedRange(range: 4...13, in: rawString), children: []),
//                             Node(content: " bolded", type: .body, rangeInOrigin: ClosedRange(range: 14...20, in: rawString), children: [])]
//
//        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
//        XCTAssertEqual(nodes, expectedNodes)
//    }
//
//    func testItalicSubsectionInMiddle() async throws {
//        let rawString: Substring = "t *italic* not italic"
//        let nodes = substringsNodeGenerator.findNodes(in: rawString)
//
//        let expectedNodes = [Node(content: "t ", type: .body, rangeInOrigin: ClosedRange(range: 0...1, in: rawString), children: []),
//                             Node(content: "italic", type: .italic, rangeInOrigin: ClosedRange(range: 2...9, in: rawString), children: []),
//                             Node(content: " not italic", type: .body, rangeInOrigin: ClosedRange(range: 10...20, in: rawString), children: [])]
//
//        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
//        XCTAssertEqual(nodes.compactMap { $0.rangeInOrigin }, expectedNodes.compactMap { $0.rangeInOrigin })
//        XCTAssertEqual(nodes, expectedNodes)
//    }
//
//    func testItalicSubsectionOnBeginning() async throws {
//        let rawString: Substring = "*italic* not italic"
//        let nodes = substringsNodeGenerator.findNodes(in: rawString)
//
//        let expectedNodes = [Node(content: "italic", type: .italic, rangeInOrigin: ClosedRange(range: 0...7, in: rawString), children: []),
//                             Node(content: " not italic", type: .body, rangeInOrigin: ClosedRange(range: 8...18, in: rawString), children: [])]
//
//        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
//        XCTAssertEqual(nodes.compactMap { $0.rangeInOrigin }, expectedNodes.compactMap { $0.rangeInOrigin })
//        XCTAssertEqual(nodes, expectedNodes)
//    }
//
    func testItalicSubsectionOnEnd() async throws {
        let rawString: Substring = "not italic *italic*"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)

        let expectedNodes = [Node(content: "not italic ", type: .body, parent: nil, children: []),
                             Node(content: "italic", type: .italic, parent: nil, children: [])]

        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
//        XCTAssertEqual(nodes.compactMap { $0.rangeInOrigin }, expectedNodes.compactMap { $0.rangeInOrigin })
        XCTAssertEqual(nodes, expectedNodes)
    }
//
//    // MARK: - Siblings
//
    func testItalicAndBoldSubsectionAsSublings() async throws {
        let rawString: Substring = "not italic *italic* **bolded**"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)

        let expectedNodes = [Node(content: "not italic ", type: .body, parent: nil, children: []),
                             Node(content: "italic", type: .italic, parent: nil, children: []),
                             Node(content: " ", type: .body, parent: nil, children: []),
                             Node(content: "bolded", type: .bold, parent: nil, children: [])]

        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
//        XCTAssertEqual(nodes.compactMap { $0.rangeInOrigin }, expectedNodes.compactMap { $0.rangeInOrigin })
        XCTAssertEqual(nodes, expectedNodes)
    }

}

extension ClosedRange where Bound == String.Index {
    
    init(range inputRange: ClosedRange<Int>, in source: Substring) {
        let startIndex = source.index(source.startIndex, offsetBy: inputRange.lowerBound, limitedBy: source.endIndex)!
        let endIndex = source.index(source.startIndex, offsetBy: inputRange.upperBound, limitedBy: source.endIndex)!
        self = startIndex...endIndex
    }
    
}
