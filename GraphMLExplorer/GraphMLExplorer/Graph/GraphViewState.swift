//
//  GraphViewState.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 10/07/2023.
//

import Foundation
import SwiftGraph

final class GraphViewState: ObservableObject {
    @Published var currentNode: String
    @Published var childNodes: [String]

    private let graph: UnweightedGraph<String>
    private let fallbackTitle = "No nodes in loaded graph!"

    init(graph: UnweightedGraph<String>) {
        self.graph = graph
        let firstVertex = graph.vertices.first ?? fallbackTitle
        let neighbors = graph.neighborsForVertex(firstVertex) ?? []
        self.currentNode = firstVertex
        self.childNodes = neighbors
    }

    func selectVertex(vertex: String) {
        guard graph.vertexInGraph(vertex: vertex) else {
            return
        }
        self.currentNode = vertex
        self.childNodes = graph.neighborsForVertex(vertex) ?? []
    }
}
