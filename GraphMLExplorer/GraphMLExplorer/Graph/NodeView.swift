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

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(title: "Sample node")
    }
}
