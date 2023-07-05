//
//  AppStart.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Foundation
import SwiftGraph

protocol UnweightedGraphLoaderProtocol {
    func start() -> UnweightedGraph<String>
}

struct UnweightedGraphLoader: UnweightedGraphLoaderProtocol {

    private let fileLoader: FileLoadProtocol
    private let graphParser: GraphMLParserProtocol

    init(fileLoader: FileLoadProtocol = FileLoader(),
         graphParser: GraphMLParserProtocol = GraphMLParser()) {
        self.fileLoader = fileLoader
        self.graphParser = graphParser
    }

    func start() -> UnweightedGraph<String> {
        var fileContent: String = ""
        do {
            fileContent = try fileLoader.loadAppBundleFile(xmlName: "sample")
        } catch let error {
            print("Start error \(error)")
        }
        return graphParser.parse(xmlString: fileContent)
    }
}
