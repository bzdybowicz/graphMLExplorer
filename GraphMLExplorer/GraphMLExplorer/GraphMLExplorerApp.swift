//
//  GraphMLExplorerApp.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import SwiftUI

@main
struct GraphMLExplorerApp: App {

    private let appStarter: AppStartProtocol

    init() {
        self.init(appStarter: AppStart())
    }

    init(appStarter: AppStartProtocol = AppStart()) {
        self.appStarter = appStarter

        appStarter.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
