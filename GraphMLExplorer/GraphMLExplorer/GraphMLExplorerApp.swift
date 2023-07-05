//
//  GraphMLExplorerApp.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import SwiftUI

@main
struct GraphMLExplorerApp: App {

    private let appStarter: UnweightedGraphLoaderProtocol

    init() {
        self.init(appStarter: UnweightedGraphLoader())
    }

    init(appStarter: UnweightedGraphLoaderProtocol) {
        self.appStarter = appStarter
    }

    var body: some Scene {
        WindowGroup {
            GraphView(graph: appStarter.start())
        }
    }
}
