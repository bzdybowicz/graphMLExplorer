//
//  BZGraph.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation

struct BZGraph {

    static let empty = BZGraph(vertices: [], edges: [], directed: .undirected)
    let edges: [EdgeStruct]
    var vertices: [String]
    let directed: Directed

    var edgeCount: Int { edges.count }

    init(vertices: [String], edges: [EdgeStruct], directed: Directed) {
        self.vertices = vertices
        self.edges = edges
        self.directed = directed
    }

    func neighborsForVertex(_ vertex: String) -> [String] {
        var neighbors: [String] = []
        for edge in edges {
            if edge.source == vertex {
                neighbors.append(edge.target)
            } else if edge.target == vertex {
                neighbors.append(edge.source)
            }
        }
        return neighbors
    }

    func vertexInGraph(vertex: String) -> Bool {
        vertices.firstIndex(of: vertex) != nil
    }

}
