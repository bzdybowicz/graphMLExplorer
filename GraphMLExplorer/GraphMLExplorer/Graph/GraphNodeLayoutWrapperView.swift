//
//  GraphNodeLayoutWrapper.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 14/07/2023.
//

import Foundation
import SwiftUI

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
            .roundedRectangle()
        case .horizontal:
            HStack {
                GraphNodeView(node: node, state: state)
            }
            .roundedRectangle()
        }
    }
}
