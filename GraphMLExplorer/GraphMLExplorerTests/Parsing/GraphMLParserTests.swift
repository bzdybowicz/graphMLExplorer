//
//  GraphMLParserTests.swift
//  GraphMLExplorerTests
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation
@testable import GraphMLExplorer
import XCTest

extension Graph: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        let vertices = Set(lhs.vertices) == Set(rhs.vertices)
        let directed = lhs.directed == rhs.directed
        let edges = Set(lhs.edges) == Set(rhs.edges)
        print("LHS count \(lhs.vertices.count), rhs \(rhs.vertices.count)")
        print("Vertices \(vertices), directed \(directed), edges \(edges)")
        return vertices && directed && edges
    }
}

final class GraphMLParserTests: XCTestCase {

    func testParseUndirected11nodes13edges() {
        let sut = GraphMLParser()
        let sampleString =
"""
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\"  \n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns\n     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">\n  <graph id=\"G\" edgedefault=\"undirected\">\n    <node id=\"n0\"/>\n    <node id=\"n1\"/>\n    <node id=\"n2\"/>\n    <node id=\"n3\"/>\n    <node id=\"n4\"/>\n    <node id=\"n5\"/>\n    <node id=\"n6\"/>\n    <node id=\"n7\"/>\n    <node id=\"n8\"/>\n    <node id=\"n9\"/>\n    <node id=\"n10\"/>\n    <edge source=\"n0\" target=\"n2\"/>\n    <edge source=\"n0\" target=\"n1\"/>\n    <edge source=\"n1\" target=\"n2\"/>\n    <edge source=\"n2\" target=\"n3\"/>\n    <edge source=\"n3\" target=\"n5\"/>\n    <edge source=\"n3\" target=\"n4\"/>\n    <edge source=\"n4\" target=\"n6\"/>\n    <edge source=\"n6\" target=\"n5\"/>\n    <edge source=\"n5\" target=\"n7\"/>\n    <edge source=\"n6\" target=\"n8\"/>\n    <edge source=\"n8\" target=\"n7\"/>\n    <edge source=\"n8\" target=\"n9\"/>\n    <edge source=\"n8\" target=\"n10\"/>\n  </graph>\n</graphml>
"""
        let graph = sut.parse(xmlString: sampleString)
        let expectedVertices = ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "n9", "n10"]
        let expectedEdges = [EdgeStruct(source: "n0", target: "n1"),
                             EdgeStruct(source: "n0", target: "n2"),
                             EdgeStruct(source: "n1", target: "n2"),
                             EdgeStruct(source: "n2", target: "n3"),
                             EdgeStruct(source: "n3", target: "n5"),
                             EdgeStruct(source: "n3", target: "n4"),
                             EdgeStruct(source: "n4", target: "n6"),
                             EdgeStruct(source: "n6", target: "n5"),
                             EdgeStruct(source: "n5", target: "n7"),
                             EdgeStruct(source: "n6", target: "n8"),
                             EdgeStruct(source: "n8", target: "n7"),
                             EdgeStruct(source: "n8", target: "n9"),
                             EdgeStruct(source: "n8", target: "n10")]
        XCTAssertEqual(graph, Graph(vertices: expectedVertices, edges: expectedEdges, directed: .undirected))
    }


    func testParseDirected10vertices11edges() {
        let sut = GraphMLParser()
        let sampleString =
"""
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\"  \n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns\n     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">\n  <graph id=\"G\" edgedefault=\"directed\">\n    <node id=\"n0\"/>\n    <node id=\"n1\"/>\n    <node id=\"n2\"/>\n    <node id=\"n3\"/>\n    <node id=\"n4\"/>\n    <node id=\"n5\"/>\n    <node id=\"n6\"/>\n    <node id=\"n8\"/>\n    <node id=\"n9\"/>\n    <node id=\"n10\"/>\n    <edge source=\"n0\" target=\"n2\"/>\n    <edge source=\"n0\" target=\"n1\"/>\n    <edge source=\"n1\" target=\"n2\"/>\n    <edge source=\"n2\" target=\"n3\"/>\n    <edge source=\"n3\" target=\"n5\"/>\n    <edge source=\"n3\" target=\"n4\"/>\n    <edge source=\"n4\" target=\"n6\"/>\n    <edge source=\"n6\" target=\"n5\"/>\n    <edge source=\"n6\" target=\"n8\"/>\n   <edge source=\"n8\" target=\"n9\"/>\n    <edge source=\"n8\" target=\"n10\"/>\n  </graph>\n</graphml>
"""
        let graph = sut.parse(xmlString: sampleString)
        let expectedVertices = ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "n8", "n9", "n10"]
        let expectedEdges = [EdgeStruct(source: "n0", target: "n1"),
                             EdgeStruct(source: "n0", target: "n2"),
                             EdgeStruct(source: "n1", target: "n2"),
                             EdgeStruct(source: "n2", target: "n3"),
                             EdgeStruct(source: "n3", target: "n5"),
                             EdgeStruct(source: "n3", target: "n4"),
                             EdgeStruct(source: "n4", target: "n6"),
                             EdgeStruct(source: "n6", target: "n5"),
                             EdgeStruct(source: "n6", target: "n8"),
                             EdgeStruct(source: "n8", target: "n9"),
                             EdgeStruct(source: "n8", target: "n10")]
        XCTAssertEqual(graph, Graph(vertices: expectedVertices, edges: expectedEdges, directed: .directed))
    }

    static let customDataXMLString =
"""
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n    <key for=\"edge\" id=\"d0\" attr.type=\"long\" attr.name=\"LongValueName\"></key>\n    <key id=\"d1\" attr.type=\"float\" attr.name=\"FloatValueName\" for=\"graph\"></key>\n    <key for=\"all\" attr.name=\"BooleanValueName\" id=\"d2\" attr.type=\"boolean\"></key>\n    <key id=\"d3\" attr.name=\"StringValueName\" attr.type=\"string\" for=\"node\"></key>\n    <graph edgedefault=\"undirected\" id=\"G\">\n        <data key=\"d0\"></data>\n        <data key=\"d1\"></data>\n        <data key=\"d2\">true</data>\n        <data key=\"d3\">yellow</data>\n        <edge target=\"n8\" source=\"n0\" directed=\"false\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">red</data>\n        </edge>\n        <edge target=\"n2\" source=\"n0\" directed=\"false\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">red</data>\n        </edge>\n        <node id=\"n0\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">black</data>\n        </node>\n        <edge target=\"n9\" source=\"n1\" directed=\"true\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">orange</data>\n        </edge>\n        <edge target=\"n7\" source=\"n1\" directed=\"false\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">yellow</data>\n        </edge>\n        <node id=\"n1\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">red</data>\n        </node>\n        <edge target=\"n9\" source=\"n2\" directed=\"false\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">red</data>\n        </edge>\n        <edge target=\"n2\" source=\"n2\" directed=\"false\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">magenta</data>\n        </edge>\n        <node id=\"n2\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">magenta</data>\n        </node>\n        <edge target=\"n0\" source=\"n3\" directed=\"true\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">yellow</data>\n        </edge>\n        <edge target=\"n8\" source=\"n3\" directed=\"false\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">white</data>\n        </edge>\n        <edge target=\"n6\" source=\"n3\" directed=\"true\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">red</data>\n        </edge>\n        <node id=\"n3\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">white</data>\n        </node>\n        <edge directed=\"true\" target=\"n6\" source=\"n4\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">magenta</data>\n        </edge>\n        <edge directed=\"false\" target=\"n2\" source=\"n4\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">black</data>\n        </edge>\n        <edge directed=\"true\" target=\"n7\" source=\"n4\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">black</data>\n        </edge>\n        <node id=\"n4\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">orange</data>\n        </node>\n        <edge directed=\"true\" target=\"n7\" source=\"n5\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">black</data>\n        </edge>\n        <edge directed=\"false\" target=\"n3\" source=\"n5\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">red</data>\n        </edge>\n        <edge directed=\"false\" target=\"n1\" source=\"n5\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">red</data>\n        </edge>\n        <node id=\"n5\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">yellow</data>\n        </node>\n        <edge directed=\"false\" target=\"n4\" source=\"n6\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">white</data>\n        </edge>\n        <edge directed=\"true\" target=\"n9\" source=\"n6\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">orange</data>\n        </edge>\n        <edge directed=\"false\" target=\"n8\" source=\"n6\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">orange</data>\n        </edge>\n        <node id=\"n6\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">orange</data>\n        </node>\n        <edge directed=\"true\" target=\"n6\" source=\"n7\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">white</data>\n        </edge>\n        <edge directed=\"true\" target=\"n9\" source=\"n7\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">white</data>\n        </edge>\n        <edge directed=\"false\" target=\"n2\" source=\"n7\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">magenta</data>\n        </edge>\n        <node id=\"n7\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">blue</data>\n        </node>\n        <edge directed=\"true\" target=\"n8\" source=\"n8\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">orange</data>\n        </edge>\n        <node id=\"n8\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">true</data>\n            <data key=\"d3\">orange</data>\n        </node>\n        <edge directed=\"false\" target=\"n1\" source=\"n9\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">yellow</data>\n        </edge>\n        <node id=\"n9\">\n            <data key=\"d0\"></data>\n            <data key=\"d1\"></data>\n            <data key=\"d2\">false</data>\n            <data key=\"d3\">blue</data>\n        </node>\n    </graph>\n</graphml>
"""

    func testParseCustomData() {
        let sut = GraphMLParser()
        let graph = sut.parse(xmlString: GraphMLParserTests.customDataXMLString)
        let expectedVertices = ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "n9"]
        let expectedEdges = [
            EdgeStruct(source: "n8", target: "n8"),
            EdgeStruct(source: "n9", target: "n1"),
            EdgeStruct(source: "n0", target: "n2"),
            EdgeStruct(source: "n2", target: "n2"),
            EdgeStruct(source: "n3", target: "n8"),
            EdgeStruct(source: "n6", target: "n8"),
            EdgeStruct(source: "n7", target: "n2"),
            EdgeStruct(source: "n3", target: "n0"),
            EdgeStruct(source: "n2", target: "n9"),
            EdgeStruct(source: "n5", target: "n1"),
            EdgeStruct(source: "n0", target: "n8"),
            EdgeStruct(source: "n7", target: "n9"),
            EdgeStruct(source: "n1", target: "n7"),
            EdgeStruct(source: "n7", target: "n6"),
            EdgeStruct(source: "n4", target: "n7"),
            EdgeStruct(source: "n6", target: "n4"),
            EdgeStruct(source: "n1", target: "n9"),
            EdgeStruct(source: "n5", target: "n7"),
            EdgeStruct(source: "n5", target: "n3"),
            EdgeStruct(source: "n3", target: "n6"),
            EdgeStruct(source: "n4", target: "n6"),
            EdgeStruct(source: "n4", target: "n2"),
            EdgeStruct(source: "n6", target: "n9"),
        ]
        print("expec \(expectedEdges.count), graph \(graph.edgeCount)")
        XCTAssertEqual(graph, Graph(vertices: expectedVertices, edges: expectedEdges, directed: .undirected))
    }
}
