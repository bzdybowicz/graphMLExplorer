//
//  GraphViewState.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 10/07/2023.
//

import Combine
import Foundation
import SwiftGraph

final class GraphViewState: ObservableObject {
    @Published var currentNode: String
    @Published var childNodes: [String]
    @Published var graph: UnweightedGraph<String>
    @Published var filePath: String = ""

    private let unweightedGraphLoader: UnweightedGraphLoaderProtocol
    private var cancellables: Set<AnyCancellable> = []

    private enum Constant {
        static let fallbackTitle = "No nodes in loaded graph!"
    }

    init(graph: UnweightedGraph<String>,
         unweightedGraphLoader: UnweightedGraphLoaderProtocol) {
        self.graph = graph
        let firstVertex = graph.vertices.first ?? Constant.fallbackTitle
        let neighbors = graph.neighborsForVertex(firstVertex) ?? []
        self.currentNode = firstVertex
        self.childNodes = neighbors
        self.unweightedGraphLoader = unweightedGraphLoader

        unweightedGraphLoader
            .graphPublisher
            .sink(receiveValue: { [weak self] value in
                self?.graph = value.graph
                self?.filePath = value.filePath
                self?.currentNode = value.graph.vertices.first ?? Constant.fallbackTitle
                let newChildNodes = value.graph.neighborsForVertex(firstVertex) ?? []
                self?.childNodes = newChildNodes.sorted()
            })
            .store(in: &cancellables)
    }

    func selectVertex(vertex: String) {
        guard graph.vertexInGraph(vertex: vertex) else {
            return
        }
        self.currentNode = vertex
        self.childNodes = (graph.neighborsForVertex(vertex) ?? []).sorted()
    }
}
