//
//  GraphMLParserTests.swift
//  GraphMLExplorerTests
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation
@testable import GraphMLExplorer
import XCTest

extension BZGraph: Equatable {
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

    func testParse() {
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
        XCTAssertEqual(graph, BZGraph(vertices: expectedVertices, edges: expectedEdges, directed: .undirected))
    }
}
