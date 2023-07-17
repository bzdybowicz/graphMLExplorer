//
//  GraphViewSnapshotsTests.swift
//  GraphMLExplorerTests
//
//  Created by Bartlomiej Zdybowicz on 14/07/2023.
//

import Foundation
@testable import GraphMLExplorer
import SnapshotTesting
import XCTest

final class GraphViewSnapshotsTests: XCTestCase {

    func test() {
        let loader = UnweightedGraphLoader()
        let graph = loader.start()
        let sut = GraphView(graph: graph, unweightedGraphLoader: loader)
#if os(iOS)
        assertSnapshot(matching: sut.frame(width: 1000, height: 600), as: .image, named: "iphone600x600start")
#elseif os(macOS)
#endif
        
    }

}
