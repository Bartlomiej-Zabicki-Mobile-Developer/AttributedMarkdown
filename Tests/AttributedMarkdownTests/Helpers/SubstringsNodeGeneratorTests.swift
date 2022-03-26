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
        
        let expectedNodes = [Node(content: "not bolded ", type: .body, parent: nil, children: [], isClosed: true)]
        
        XCTAssertEqual(nodes.generateContent(), expectedNodes.generateContent())
        XCTAssertEqual(nodes.generateContent(), "not bolded ")
        XCTAssertEqual(nodes, expectedNodes)
    }
    
    func testBoldSubsectionOnEnd() async throws {
        let rawString: Substring = "not bolded **bolded**"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)

        let mainNode = Node(content: "not bolded ", type: .body, parent: nil, children: [], isClosed: true)
        let child = Node(content: "bolded", type: .bold, parent: nil, children: [], isClosed: true)
        let expectedNodes = [mainNode, child]

        XCTAssertEqual(nodes.generateContent(), expectedNodes.generateContent())
        XCTAssertEqual(nodes.generateContent(), "not bolded bolded")
        XCTAssertEqual(nodes, expectedNodes)
    }

    func testBoldSubsectionOnBeginning() async throws {
        let rawString: Substring = "**bolded** not bolded "
        let nodes = substringsNodeGenerator.findNodes(in: rawString)

        let expectedNodes = [Node(content: "bolded", type: .bold, parent: nil, children: [], isClosed: true),
                             Node(content: " not bolded ", type: .body, parent: nil, children: [], isClosed: true)]

        XCTAssertEqual(nodes.generateContent(), "bolded not bolded ")
        XCTAssertEqual(nodes, expectedNodes)
    }

    func testBoldSubsectionInMiddle() async throws {
        let rawString: Substring = "not **bolded** bolded"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)

        let expectedNodes = [Node(content: "not ", type: .body, parent: nil, children: [], isClosed: true),
                             Node(content: "bolded", type: .bold, parent: nil, children: [], isClosed: true),
                             Node(content: " bolded", type: .body, parent: nil, children: [], isClosed: true)]

        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
        XCTAssertEqual(nodes, expectedNodes)
    }

    func testItalicSubsectionInMiddle() async throws {
        let rawString: Substring = "t *italic* not italic"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)

        let expectedNodes = [Node(content: "t ", type: .body, parent: nil, children: [], isClosed: true),
                             Node(content: "italic", type: .italic, parent: nil, children: [], isClosed: true),
                             Node(content: " not italic", type: .body, parent: nil, children: [], isClosed: true)]

        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
        XCTAssertEqual(nodes, expectedNodes)
    }

    func testItalicSubsectionOnBeginning() async throws {
        let rawString: Substring = "*italic* not italic"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)

        let expectedNodes = [Node(content: "italic", type: .italic, parent: nil, children: [], isClosed: true),
                             Node(content: " not italic", type: .body, parent: nil, children: [], isClosed: true)]

        XCTAssertEqual(nodes.compactMap { $0.content }, expectedNodes.compactMap { $0.content })
        XCTAssertEqual(nodes, expectedNodes)
    }

    func testItalicSubsectionOnEnd() async throws {
        let rawString: Substring = "not italic *italic*"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)
        
        let mainNode = Node(content: "not italic ", type: .body, parent: nil, children: [], isClosed: true)
        let child = Node(content: "italic", type: .italic, parent: nil, children: [], isClosed: true)
        let expectedNodes = [mainNode, child]

        XCTAssertEqual(nodes.generateContent(), expectedNodes.generateContent())
        XCTAssertEqual(nodes.generateContent(), "not italic italic")
        XCTAssertEqual(nodes, expectedNodes)
    }

    // MARK: - Siblings

    func testItalicAndBoldSubsectionAsSublings() async throws {
        let rawString: Substring = "not italic *italic* **bolded**"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)
        
        let mainNode = Node(content: "not italic ", type: .body, parent: nil, children: [], isClosed: true)
        let italicNode = Node(content: "italic", type: .italic, parent: nil, children: [], isClosed: true)
        let spaceBodyNode = Node(content: " ", type: .body, parent: nil, children: [], isClosed: true)
        let boldedNode = Node(content: "bolded", type: .bold, parent: nil, children: [], isClosed: true)

        let expectedNodes = [mainNode, italicNode, spaceBodyNode, boldedNode]
        
        XCTAssertEqual(nodes.generateContent(), "not italic italic bolded")
        XCTAssertEqual(nodes, expectedNodes)
    }
    
    // MARK: - Children

    func testItalicAndBoldSubsectionAsChildren() async throws {
        let rawString: Substring = "Test ***italic* bolded**"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)
        
        let mainNode = Node(content: "Test ", type: .body, parent: nil, children: [], isClosed: true)
        let boldedContainerNode = Node(content: "", type: .bold, parent: nil, children: [], isClosed: true)
        let italicNode = Node(content: "italic", type: .italic, parent: boldedContainerNode, children: [], isClosed: true)
        let boldedContentNode = Node(content: " bolded", type: .bold, parent: boldedContainerNode, children: [], isClosed: true)
        boldedContainerNode.children = [italicNode, boldedContentNode]

        let expectedNodes = [mainNode, boldedContainerNode]
        
        XCTAssertEqual(nodes.generateContent(), "Test italic bolded")
        XCTAssertEqual(nodes, expectedNodes)
    }
    
    func testBoldAndItalicSubsectionAsChildren() async throws {
        let rawString: Substring = "Test ***bolded** italic*"
        let nodes = substringsNodeGenerator.findNodes(in: rawString)
        
        let mainNode = Node(content: "Test ", type: .body, parent: nil, children: [], isClosed: true)
        let boldedContainerNode = Node(content: "", type: .bold, parent: nil, children: [], isClosed: true)
        let boldedContentNode = Node(content: "bolded", type: .bold, parent: boldedContainerNode, children: [], isClosed: true)
        let italicNode = Node(content: " italic", type: .italic, parent: boldedContainerNode, children: [], isClosed: true)
        boldedContainerNode.children = [boldedContentNode, italicNode]

        let expectedNodes = [mainNode, boldedContainerNode]
        
        XCTAssertEqual(nodes.generateContent(), "Test bolded italic")
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

extension Array where Element == Node {
    
    func generateContent() -> String {
        compactMap({
            $0.content.appending(
                $0.children.compactMap({ $0.content })
                    .compactMap({ $0 })
                    .joined()
            )
        })
            .joined()
    }
    
}
