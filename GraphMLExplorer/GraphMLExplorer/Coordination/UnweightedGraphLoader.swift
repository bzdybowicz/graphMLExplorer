//
//  AppStart.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Combine
import Foundation
import SwiftGraph

protocol UnweightedGraphLoaderProtocol {
    func start() -> UnweightedGraph<String>

    func load(fileURL: URL)

    var graphPublisher: AnyPublisher<UnweightedGraph<String>, Never> { get }
}

struct UnweightedGraphLoader: UnweightedGraphLoaderProtocol {

    var graphPublisher: AnyPublisher<UnweightedGraph<String>, Never> { subject.eraseToAnyPublisher() }

    private let fileLoader: FileLoadProtocol
    private let graphParser: GraphMLParserProtocol
    private let subject = PassthroughSubject<UnweightedGraph<String>, Never>()

    init(fileLoader: FileLoadProtocol = FileLoader(),
         graphParser: GraphMLParserProtocol = GraphMLParser()) {
        self.fileLoader = fileLoader
        self.graphParser = graphParser
    }

    func load(fileURL: URL) {
        var fileContent: String = ""
        do {
            fileContent = try fileLoader.load(fileURL: fileURL)
        } catch let error {
            print("File load error \(error)")
        }
        subject.send(graphParser.parse(xmlString: fileContent))
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
