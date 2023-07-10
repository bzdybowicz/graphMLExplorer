//
//  NodeView.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import SwiftUI

struct GraphNodeView: View {
    @ObservedObject var node: GraphNode
    @ObservedObject var state: GraphViewState

    var body: some View {
        VStack {
            Text(node.label)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)

            if !node.neighbors.isEmpty {
                ForEach(node.neighbors, id: \.id) { neighbor in
                    GraphNodeView(node: GraphNode(label: neighbor.label, neighbors: neighbor.neighbors), state: state)
                        .padding(.leading).onTapGesture {
                            print("Tap on \(neighbor.label)")
                            state.selectVertex(vertex: neighbor.label)
                        }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
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
