//
//  ContentView.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Combine
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
        graphViewState.childNodes.map { _ in
            GridItem(.adaptive(minimum: 20))
        }
    }

    @State private var importing = false
    @ObservedObject private var graphViewState: GraphViewState

    private let unweightedGraphLoader: UnweightedGraphLoaderProtocol

    init(graph: UnweightedGraph<String>,
         unweightedGraphLoader: UnweightedGraphLoaderProtocol) {
        self.graph = graph
        self.unweightedGraphLoader = unweightedGraphLoader
        graphViewState = GraphViewState(graph: graph, unweightedGraphLoader: unweightedGraphLoader)
    }

    var body: some View {
        HStack {
            GraphNodeLayoutWrapperView(
                layoutType: .horizontal,
                node: GraphNode(
                    label: graphViewState.currentNode,
                    neighbors: graphViewState.childNodes.map {
                        let neighbors = graph.neighborsForVertex($0) ?? []
                        print("NESTED NEIGHs \(neighbors)")
                        return GraphNode(label: $0,
                                         neighbors: neighbors.map {
                            GraphNode(label: $0, neighbors: [])
                        })
                    }
                ),
                state: graphViewState
            )
            Button("Pick new graphML file") {
                importing = true
            }
            .fileImporter(isPresented: $importing,
                          allowedContentTypes: [.xml]) { result in
                switch result {
                case .success(let success):
                    print("success \(success)")
                    //unweightedGraphLoader.load(filePath: success.absoluteString)
                    unweightedGraphLoader.load(fileURL: success)
                case .failure(let failure):
                    print("error \(failure)")
                }
            }
        }
//        onReceive(graphViewState.$graph) { value in
//            print("On received \(value)")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graph: UnweightedGraph(), unweightedGraphLoader: UnweightedGraphLoader())
    }
}
