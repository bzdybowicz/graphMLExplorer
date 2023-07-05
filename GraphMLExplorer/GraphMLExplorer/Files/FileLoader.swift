//
//  DefaultLoader.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Foundation
import SwiftyXMLParser

protocol FileLoadProtocol {
    func load(filePath: String) throws -> String
    func loadAppBundleFile(xmlName: String) throws -> String
}

enum FileLoaderError: Error {
    case fileDoesNotExist
}

struct FileLoader: FileLoadProtocol {

    func load(filePath: String) throws -> String {
        ""
    }

    func loadAppBundleFile(xmlName: String) throws -> String {
        guard let path = Bundle.main.path(forResource: xmlName, ofType: "xml") else {
            throw FileLoaderError.fileDoesNotExist
        }
        let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        return string
    }
}
