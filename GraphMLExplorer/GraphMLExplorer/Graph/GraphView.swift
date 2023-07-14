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

    private var node: GraphNode {
        TimeMeasure().event(.buildingNode)
        let verticesCount = graphViewState.graph.vertices.count
        let edgesCount = graphViewState.graph.edgeCount
        print("Vertices \(verticesCount), edges count \(edgesCount)")
        let showForthLevel = verticesCount < 1000 && edgesCount < 2000
        print("show forth \(showForthLevel)")
        return GraphNode(label: graphViewState.currentNode,
                         nestLevel: .first,
                         neighbors: graphViewState.childNodes.map {
            let neighbors = graphViewState.graph.neighborsForVertex($0) ?? []
            return GraphNode(label: $0,
                             nestLevel: .second,
                             neighbors: neighbors.map {
                let neighbors = graphViewState.graph.neighborsForVertex($0) ?? []
                return GraphNode(label: $0,
                                 nestLevel: .third,
                                 neighbors: neighbors.map { GraphNode(label: $0,
                                                                      nestLevel: .fourth,
                                                                      neighbors: [])
                })
            })
        })
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView([.horizontal, .vertical]) {
                    HStack(alignment: .center) {
                        GraphNodeLayoutWrapperView(
                            layoutType: .horizontal,
                            node: node,
                            state: graphViewState
                        )
                    }
#if os(macOS)
                    // Without this mac os tap gestures are broken. (touch areas don't match their views)
                    // With this on iOS scroll is broken.
                    // My bet is on some SwiftUI imperfection. Maybe I'm missing sth, but it seems pointless to try to invest yet more time in it.
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.9, alignment: .center)
#endif
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
