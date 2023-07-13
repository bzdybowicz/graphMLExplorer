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

enum NestLevel {
    case first
    case second
    case third
    case fourth
    case end

    var next: NestLevel {
        switch self {
        case .first: return .second
        case .second: return .third
        case .third: return .fourth
        case .fourth: return .end
        case .end: return .end
        }
    }
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
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
        case .horizontal:
            HStack {
                GraphNodeView(node: node, state: state)
            }
            .padding()
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
        .onTapGesture {
            print("## TAP 3. TAPPED node \(node.label)")
            state.selectVertex(vertex: node.label)
        }

        ForEach(node.neighbors, id: \.label) { value in
            GraphNodeLayoutWrapperView(layoutType: .vertical,
                                       node: GraphNode(label: value.label,
                                                       neighbors: value.neighbors),
                                       state: state)
//            .onTapGesture {
//                print("## TAP 4. TAPPED node \(value.label)")
//                state.selectVertex(vertex: value.label)
//            }
        }


    }
}

final class GraphNode: Identifiable, ObservableObject {
    let id = UUID()
    let label: String
    let neighbors: [GraphNode]

    init(label: String, neighbors: [GraphNode]) {
        self.label = label
        self.neighbors = neighbors.sorted(by: {
            $0.label > $1.label
        })
    }
}
