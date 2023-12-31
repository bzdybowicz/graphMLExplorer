//
//  ContentView.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Combine
import SwiftUI

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

    init(graph: Graph,
         unweightedGraphLoader: UnweightedGraphLoaderProtocol) {
        self.unweightedGraphLoader = unweightedGraphLoader
        _graphViewState = StateObject(wrappedValue: GraphViewState(graph: graph,
                                                                   unweightedGraphLoader: unweightedGraphLoader))
    }

    private var node: GraphNode {
        TimeMeasure.instance.event(.buildingNode)
        let verticesCount = graphViewState.graph.vertices.count
        let edgesCount = graphViewState.graph.edgeCount
        print("Vertices \(verticesCount), edges count \(edgesCount)")
        let showForthLevel = verticesCount < 1000 && edgesCount < 2000
        print("show forth \(showForthLevel)")
        return GraphNode(vertice: graphViewState.currentNode,
                         nestLevel: .first,
                         neighbors: graphViewState.childNodes.map {
            let neighbors = graphViewState.graph.neighborsForVertex($0)
            return GraphNode(vertice: $0,
                             nestLevel: .second,
                             neighbors: neighbors.map {
                let neighbors = graphViewState.graph.neighborsForVertex($0)
                return GraphNode(vertice: $0,
                                 nestLevel: .third,
                                 neighbors: neighbors.map { GraphNode(vertice: $0,
                                                                      nestLevel: .fourth,
                                                                      neighbors: [])
                })
            })
        })
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
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
                Spacer()
                ScrollView([.horizontal, .vertical]) {
                    HStack(alignment: .center) {
                        GraphNodeLayoutWrapperView(
                            layoutType: .horizontal,
                            node: node,
                            state: graphViewState
                        )
                    }
                    // If content frames are smaller than scroll view then scroll view is broken (either taps - views with touch areas
                    // don't match or there is no scroll indicators when reloaded).
                    // https://stackoverflow.com/questions/61183673/swiftui-scrollview-does-not-center-content-when-content-fits-scrollview-bounds
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                    .background(Color.white.opacity(0.9))
                }
                if graphViewState.animating {
                    ProgressView("Loading graph")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graph: .empty, unweightedGraphLoader: UnweightedGraphLoader())
    }
}
