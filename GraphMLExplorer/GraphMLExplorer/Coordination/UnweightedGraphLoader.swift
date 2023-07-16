//
//  AppStart.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Combine
import Foundation

struct GraphData {
    let filePath: String
    let graph: Graph
}

protocol UnweightedGraphLoaderProtocol {
    func start() -> Graph

    func load(fileURL: URL)

    var graphPublisher: AnyPublisher<GraphData, Never> { get }
}

struct UnweightedGraphLoader: UnweightedGraphLoaderProtocol {

    var graphPublisher: AnyPublisher<GraphData, Never> { subject.eraseToAnyPublisher() }

    private let fileLoader: FileLoadProtocol
    private let graphParser: GraphMLParserProtocol
    private let subject = PassthroughSubject<GraphData, Never>()

    init(fileLoader: FileLoadProtocol = FileLoader(),
         graphParser: GraphMLParserProtocol = GraphMLParser()) {
        self.fileLoader = fileLoader
        self.graphParser = graphParser
    }

    func load(fileURL: URL) {
        var fileContent: String = ""
        do {
            TimeMeasure.instance.event(.pickFile)
            fileContent = try fileLoader.load(fileURL: fileURL)
            TimeMeasure.instance.event(.fileLoaded)
        } catch let error {
            print("File load error \(error)")
        }
        TimeMeasure.instance.event(.parsingStart)
        let graph = graphParser.parse(xmlString: fileContent)
        TimeMeasure.instance.event(.parsingEnd)
        subject.send(GraphData(filePath: fileURL.absoluteString, graph: graph))
    }

    func start() -> Graph {
        var fileContent: String = ""
        do {
            fileContent = try fileLoader.loadAppBundleFile(xmlName: "sample")
        } catch let error {
            print("Start error \(error)")
        }
        let startGraph = graphParser.parse(xmlString: fileContent)
        return startGraph
    }
}
