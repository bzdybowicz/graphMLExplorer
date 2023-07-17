//
//  GraphViewState.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 10/07/2023.
//

import Combine
import Foundation

final class GraphViewState: ObservableObject {
    @Published var currentNode: Vertice
    @Published var childNodes: [Vertice]
    @Published var graph: Graph //UnweightedGraph<String>
    @Published var filePath: String = ""
    @Published var animating: Bool = false

    private let unweightedGraphLoader: UnweightedGraphLoaderProtocol
    private var cancellables: Set<AnyCancellable> = []

    static let fallbackVertice = Vertice(id: Constant.fallbackTitle)

    private enum Constant {
        static let fallbackTitle = "No nodes in loaded graph!"
    }

    init(graph: Graph,
         unweightedGraphLoader: UnweightedGraphLoaderProtocol) {
        self.graph = graph
        let firstVertex = graph.vertices.first ?? GraphViewState.fallbackVertice
        let neighbors = graph.neighborsForVertex(firstVertex)
        self.currentNode = firstVertex
        self.childNodes = Array(neighbors)
        self.unweightedGraphLoader = unweightedGraphLoader

        unweightedGraphLoader
            .graphPublisher
            .sink(receiveValue: { [weak self] value in
                self?.graph = value.graph
                self?.filePath = value.filePath
                self?.currentNode = value.graph.vertices.first ?? GraphViewState.fallbackVertice
                let newChildNodes = value.graph.neighborsForVertex(firstVertex)
                self?.childNodes = newChildNodes.sorted()
            })
            .store(in: &cancellables)
    }

    func selectVertex(vertice: Vertice) {
        guard graph.vertexInGraph(vertice: vertice) else {
            return
        }
        self.currentNode = vertice
        self.childNodes = (graph.neighborsForVertex(vertice)).sorted()
    }
}
