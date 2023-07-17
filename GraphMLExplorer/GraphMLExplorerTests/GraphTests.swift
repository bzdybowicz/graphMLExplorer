//
//  GraphTests.swift
//  GraphMLExplorerTests
//
//  Created by Bartlomiej Zdybowicz on 17/07/2023.
//

import Foundation
@testable import GraphMLExplorer
import XCTest

final class GraphTests: XCTestCase {

    func testNeighbors() {
        let vertices: Set<Vertice> = Set(["n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "n9", "n10"].map { Vertice(id: $0) })
        let edges: Set<EdgeStruct> = [EdgeStruct(source: "n0", target: "n1", directed: .undirected),
                                      EdgeStruct(source: "n0", target: "n2", directed: .undirected),
                                      EdgeStruct(source: "n1", target: "n2", directed: .undirected),
                                      EdgeStruct(source: "n2", target: "n3", directed: .undirected),
                                      EdgeStruct(source: "n3", target: "n5", directed: .undirected),
                                      EdgeStruct(source: "n3", target: "n4", directed: .undirected),
                                      EdgeStruct(source: "n4", target: "n6", directed: .undirected),
                                      EdgeStruct(source: "n6", target: "n5", directed: .undirected),
                                      EdgeStruct(source: "n5", target: "n7", directed: .undirected),
                                      EdgeStruct(source: "n6", target: "n8", directed: .undirected),
                                      EdgeStruct(source: "n8", target: "n7", directed: .undirected),
                                      EdgeStruct(source: "n8", target: "n9", directed: .undirected),
                                      EdgeStruct(source: "n8", target: "n10", directed: .undirected)]
        let graph = Graph(vertices: vertices, edges: edges, directed: .undirected)
        let expected1: Set<Vertice> = [Vertice(id: "n1"), Vertice(id: "n2")]
        XCTAssertEqual(expected1, graph.neighborsForVertex(Vertice(id: "n0")))
    }
}
