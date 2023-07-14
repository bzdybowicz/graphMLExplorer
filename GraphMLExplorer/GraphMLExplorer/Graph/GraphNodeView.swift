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

struct GraphNodeView: View {
    @ObservedObject var node: GraphNode
    @ObservedObject var state: GraphViewState

    var body: some View {
        ZStack {
            Text(node.label)
                .font(.body)
                .foregroundColor(.white)
                .fixedSize()
        }
        .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
        .background(Color.blue)
        .cornerRadius(4)
        .onTapGesture {
            state.selectVertex(vertex: node.label)
        }

        ForEach(node.neighbors, id: \.label) { value in
            GraphNodeLayoutWrapperView(layoutType: node.nestLevel.layoutType,
                                       node: GraphNode(label: value.label,
                                                       nestLevel: node.nestLevel.next,
                                                       neighbors: value.neighbors),
                                       state: state)
        }
    }
}
