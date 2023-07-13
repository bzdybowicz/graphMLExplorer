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

    private var columns: [GridItem] {
        graphViewState.childNodes.map { _ in
            GridItem(.adaptive(minimum: 20))
        }
    }

    @State private var importing = false
    @StateObject private var graphViewState: GraphViewState

    private let unweightedGraphLoader: UnweightedGraphLoaderProtocol

    init(graph: UnweightedGraph<String>,
         unweightedGraphLoader: UnweightedGraphLoaderProtocol) {
        self.unweightedGraphLoader = unweightedGraphLoader
        _graphViewState = StateObject(wrappedValue: GraphViewState(graph: graph,
                                                                   unweightedGraphLoader: unweightedGraphLoader))
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView([.vertical, .horizontal]) {
                    HStack(alignment: .center) {
                        GraphNodeLayoutWrapperView(
                            layoutType: .horizontal,
                            node: GraphNode(
                                label: graphViewState.currentNode,
                                neighbors:
                                    graphViewState.childNodes.map {
                                        let neighbors = graphViewState.graph.neighborsForVertex($0) ?? []
                                        return GraphNode(label: $0,
                                                         neighbors: neighbors.map {
                                            let neighbors = graphViewState.graph.neighborsForVertex($0) ?? []
                                            return GraphNode(label: $0, neighbors:
                                                                neighbors.map {
                                                return GraphNode(label: $0, neighbors: [])
                                            })
                                        })
                                    }),
                            state: graphViewState
                        )
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.9, alignment: .center)
                    .background(Color.white.opacity(0.9))
                    HStack {
                        Button("Pick new graphML file") {
                            importing = true
                        }
                        .fileImporter(isPresented: $importing,
                                      allowedContentTypes: [.xml]) { result in
                            switch result {
                            case .success(let success):
                                print("success \(success)")
                                unweightedGraphLoader.load(fileURL: success)
                            case .failure(let failure):
                                print("error \(failure)")
                            }
                        }
                        Text(graphViewState.filePath)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graph: UnweightedGraph(), unweightedGraphLoader: UnweightedGraphLoader())
    }
}
