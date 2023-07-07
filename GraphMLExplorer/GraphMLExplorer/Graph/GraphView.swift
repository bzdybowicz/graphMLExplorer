//
//  ContentView.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import SwiftUI
import SwiftGraph

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

final class GraphViewState: ObservableObject {
    @Published var currentNode: String
    @Published var childNodes: [String]

    init(currentNode: String, childNodes: [String]) {
        self.currentNode = currentNode
        self.childNodes = childNodes
    }
}

struct GraphView: View {

    private let graph: UnweightedGraph<String>
    private let fallbackTitle = "No nodes in loaded graph!"

    private var columns: [GridItem] {
        state.childNodes.map { _ in
            GridItem(.adaptive(minimum: 20))
        }
    }

    @StateObject var state: GraphViewState

    init(graph: UnweightedGraph<String>) {
        self.graph = graph
        let firstVertex = graph.vertices.first ?? fallbackTitle
        let neighbors = graph.neighborsForVertex(firstVertex) ?? []
        self.state = GraphViewState(currentNode: firstVertex,
                               childNodes: neighbors)

        print("state \(firstVertex), \(neighbors)")
    }

    var body: some View {
        GraphNodeView(
            node:
                GraphNode(
                    label: state.currentNode,
                    neighbors: state.childNodes.map {
                        let neighbors = graph.neighborsForVertex($0) ?? []
                        print("NESTED NEIGHs \(neighbors)")
                        return GraphNode(label: $0,
                                         neighbors: neighbors.map {
                            GraphNode(label: $0, neighbors: [])
                        })
                    }
                )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graph: UnweightedGraph())
    }
}
