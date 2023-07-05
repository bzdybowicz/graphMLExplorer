//
//  GraphMLParser.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Foundation
import SwiftyXMLParser
import SwiftGraph

protocol XMLParserProtocol {

}

protocol GraphMLParserProtocol {
    func parse(xmlString: String) -> (any Graph)?
}

struct GraphMLParser: GraphMLParserProtocol {

    private enum Constant {
        static let graphmlMarker = "graphml"
        static let graphMarker = "graph"
        static let node = "node"
        static let edge = "edge"
        static let target = "target"
        static let source = "source"
        static let id = "id"
    }

    init() {
    }

    func parse(xmlString: String) -> (any Graph)? {
        guard let data = xmlString.data(using: .utf8) else {
            return nil
        }
        let xml = XML.parse(data)
        switch xml {
        case .singleElement(let element):
            let graphMLElement = getGraphXMLElement(element: element)
            let graphElement = getGraphElement(element: graphMLElement)
            return setupGraph(from: graphElement)
        case .sequence(let elements):
            print("Sequence elements \(elements)")
        case .failure(let error):
            print("XML failure \(error)")
        }
        return nil
    }

    private func getGraphXMLElement(element: XML.Element?) -> XML.Element? {
        element?.childElements.first { element in
            element.name == Constant.graphmlMarker
        }
    }

    private func getGraphElement(element: XML.Element?) -> XML.Element? {
        element?.childElements.first { element in
            element.name == Constant.graphMarker
        }
    }

    private func setupGraph(from element: XML.Element?) -> (any Graph)? {
        guard let element = element else { return nil }
        let graph = UnweightedGraph<String>()
        for child in element.childElements {
            print("Child \(child)")
            if child.name == Constant.node {
                if let name = child.attributes[Constant.id] {
                    _ = graph.addVertex(name)
                } else {
                    // throw error?
                }
            } else if child.name == Constant.edge {
                if let source = child.attributes[Constant.source] {
                    if let target = child.attributes[Constant.target] {
                        graph.addEdge(from: source, to: target)
                    } else {
                        // not sure yet
                    }
                }
            }
        }
        return graph
    }

}
