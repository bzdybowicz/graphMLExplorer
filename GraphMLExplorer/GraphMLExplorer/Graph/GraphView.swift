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



struct GraphView: View {

    private let graph: UnweightedGraph<String>

    private var columns: [GridItem] {
        state.childNodes.map { _ in
            GridItem(.adaptive(minimum: 20))
        }
    }

    @StateObject private var state: GraphViewState

    init(graph: UnweightedGraph<String>) {
        self.graph = graph

        _state = StateObject(wrappedValue: GraphViewState(graph: graph))
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
                ),
            state: state
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graph: UnweightedGraph())
    }
}
