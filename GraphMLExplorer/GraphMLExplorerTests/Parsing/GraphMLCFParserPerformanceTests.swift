//
//  GraphMLCFParserPerformanceTests.swift
//  GraphMLExplorerTests
//
//  Created by Bartlomiej Zdybowicz on 17/07/2023.
//

import Foundation
@testable import GraphMLExplorer
import XCTest

final class GraphMLsParsersPerformanceTests: XCTestCase {

    func test() {
        measure {
            let fileLoader = FileLoader()
            let sut = GraphMLCoreFoundationParser()
            guard let string = try? fileLoader.loadAppBundleFile(xmlName: "10000edgeMin3edgeMax4") else {
                XCTFail("File error!")
                return
            }
            let _ = sut.parse(xmlString: string)
        }
    }
}
