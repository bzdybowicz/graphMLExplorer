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
            Text(node.vertice.id)
                .font(.body)
                .foregroundColor(.white)
                .fixedSize()
        }
        .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
        .background(Color.blue)
        .cornerRadius(4)
        .onTapGesture {
            state.selectVertex(vertice: node.vertice)
        }

        ForEach(node.neighbors, id: \.vertice.id) { value in
            GraphNodeLayoutWrapperView(layoutType: node.nestLevel.layoutType,
                                       node: GraphNode(vertice: value.vertice,
                                                       nestLevel: node.nestLevel.next,
                                                       neighbors: value.neighbors),
                                       state: state)
        }
    }
}
