//
//  GraphMLExplorerApp.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import SwiftUI

@main
struct GraphMLExplorerApp: App {

    private let unweightedGraphLoader: UnweightedGraphLoaderProtocol

    init() {
        self.init(unweightedGraphLoader: UnweightedGraphLoader())
    }

    init(unweightedGraphLoader: UnweightedGraphLoaderProtocol) {
        self.unweightedGraphLoader = unweightedGraphLoader
    }

    var body: some Scene {
        WindowGroup {
            GraphView(graph: unweightedGraphLoader.start(), unweightedGraphLoader: unweightedGraphLoader)
        }
    }
}
