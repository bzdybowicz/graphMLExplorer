//
//  NodeView.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import SwiftUI

enum LayoutType {
    case vertical
    case horizontal
}

struct GraphNodeLayoutWrapperView: View {
    let layoutType: LayoutType

    @ObservedObject var node: GraphNode
    @ObservedObject var state: GraphViewState

    var body: some View {
        switch layoutType {
        case .vertical:
            VStack {
                GraphNodeView(node: node, state: state)
            }.padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
        case .horizontal:
            HStack {
                GraphNodeView(node: node, state: state)
            }.padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
        }
    }
}

struct GraphNodeView: View {
    @ObservedObject var node: GraphNode
    @ObservedObject var state: GraphViewState

    var body: some View {
        ZStack {
            Text(node.label)
                .font(.body)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
        .background(Color.blue)
        .cornerRadius(4)

        ForEach(node.neighbors, id: \.id) { neighbor in
            GraphNodeLayoutWrapperView(layoutType: .vertical,
                                       node: GraphNode(label: neighbor.label,
                                                       neighbors: neighbor.neighbors), state: state)
            .onTapGesture {
                print("state, graph \(state.graph), vertexes \(state.graph.vertices)")
                for vertice in state.graph.vertices {
                    print("Label \(vertice.id)")
                }
                print("Tap on \(neighbor.label), parent \(node.label), \(neighbor.id)")
                print("node \(node.neighbors)")
                state.selectVertex(vertex: neighbor.label)
            }
        }
    }
}

final class GraphNode: Identifiable, ObservableObject {
    let id = UUID()
    let label: String
    let neighbors: [GraphNode]

    init(label: String, neighbors: [GraphNode]) {
        self.label = label
        self.neighbors = neighbors
    }
}


//struct GraphNodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphNodeView(node: GraphNode(label: "Sample", neighbors: []),
//                      state: GraphViewState())
//    }
//}
