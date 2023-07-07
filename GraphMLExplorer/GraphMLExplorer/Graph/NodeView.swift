//
//  NodeView.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import SwiftUI

struct NodeView: View {

    private let title: String

    init(title: String) {
        self.title = title
    }

    var body: some View {
        ZStack(alignment: .top, content: {
            Rectangle()
                .border(.blue)
            Text(title).foregroundColor(.black)
        })
    }
}

struct GraphNodeView: View {
    let node: GraphNode

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
                    GraphNodeView(node: GraphNode(label: neighbor.label, neighbors: neighbor.neighbors))
                        .padding(.leading).onTapGesture {
                            print("Tap on \(neighbor.label)")
                        }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }
}

struct GraphNode: Identifiable {
    let id = UUID()
    let label: String
    let neighbors: [GraphNode]
}


struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(title: "Sample node")
    }
}
