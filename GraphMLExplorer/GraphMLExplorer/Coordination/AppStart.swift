//
//  AppStart.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Foundation

protocol AppStartProtocol {
    func start()
}

struct AppStart: AppStartProtocol {

    private let fileLoader: FileLoadProtocol
    private let graphParser: GraphMLParserProtocol

    init(fileLoader: FileLoadProtocol = FileLoader(),
         graphParser: GraphMLParserProtocol = GraphMLParser()) {
        self.fileLoader = fileLoader
        self.graphParser = graphParser
    }

    func start() {
        var fileContent: String = ""
        do {
            fileContent = try fileLoader.loadAppBundleFile(xmlName: "sample")
        } catch let error {
            print("Start error \(error)")
        }
        graphParser.parse(xmlString: fileContent)
    }
}
