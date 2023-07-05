//
//  GraphMLParser.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Foundation
import SwiftyXMLParser

protocol XMLParserProtocol {

}

protocol GraphMLParserProtocol {
    func parse(xmlString: String)
}

struct GraphMLParser: GraphMLParserProtocol {

    init() {
    }

    func parse(xmlString: String) {
        guard let data = xmlString.data(using: .utf8) else {
            return
        }
        let xml = XML.parse(data)
        print("XML \(xml)")
    }

}
