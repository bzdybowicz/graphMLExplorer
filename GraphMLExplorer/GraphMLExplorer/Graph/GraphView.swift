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

struct GraphViewState {
    let currentNode: String
    let childNodes: [String]
}

struct GraphView: View {

    private let graph: UnweightedGraph<String>
    private let fallbackTitle = "No nodes in loaded graph!"

    private var columns: [GridItem] {
        state.childNodes.map { _ in
            GridItem(.adaptive(minimum: 20))
        }
    }

    @State private var state: GraphViewState

    init(graph: UnweightedGraph<String>) {
        self.graph = graph
        let firstVertex = graph.vertices.first ?? fallbackTitle
        let neighbors = graph.neighborsForVertex(firstVertex) ?? []
        state = GraphViewState(currentNode: firstVertex,
                               childNodes: neighbors)

        print("state \(firstVertex), \(neighbors)")
    }

    var body: some View {
        ZStack(alignment: .top, content: {
            Rectangle()
                .border(.blue)
            VStack {
                Text(state.currentNode)
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(Color.black)
                    .clipShape(Rectangle())
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 6) {
                        ForEach(state.childNodes, id: \.self) { item in
                            Text(state.currentNode)
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(Color.black)
                                .clipShape(Rectangle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(graph: UnweightedGraph())
    }
}
