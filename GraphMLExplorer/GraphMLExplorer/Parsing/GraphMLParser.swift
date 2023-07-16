//
//  GraphMLParser.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Foundation
import SwiftyXMLParser

protocol GraphMLParserProtocol {
    func parse(xmlString: String) -> Graph
}

enum Directed: String {
    case undirected
    case directed

    var isDirected: Bool {
        switch self {
        case .directed: return true
        case .undirected: return false
        }
    }

    static func create(rawValue: String?) -> Directed {
        guard let rawValue = rawValue else { return .undirected }
        return Directed(rawValue: rawValue) ?? .undirected
    }
}

struct GraphMLParser: GraphMLParserProtocol {

    private enum Constant {
        static let graphmlMarker = "graphml"
        static let graphMarker = "graph"
        static let node = "node"
        static let edge = "edge"
        static let target = "target"
        static let source = "source"
        static let edgeDefault = "edgedefault"
        static let id = "id"
    }

    func parse(xmlString: String) -> Graph {
        guard let data = xmlString.data(using: .utf8) else {
            return .empty
        }
        TimeMeasure.instance.event(.parserStart)
        let xml = XML.parse(data)
        TimeMeasure.instance.event(.parserXMLDone)
        switch xml {
        case .singleElement(let element):
            let graphMLElement = getGraphXMLElement(element: element)
            let graphElement = getGraphElement(element: graphMLElement)
            let graph = setupGraph(from: graphElement)
            TimeMeasure.instance.event(.parserRestDone)
            return graph
        case .sequence(let elements):
            print("Sequence elements \(elements)")
        case .failure(let error):
            print("XML failure \(error)")
        }
        return .empty
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

    private func setupGraph(from element: XML.Element?) -> Graph {
        guard let element = element else { return .empty }
        let directed: Directed = Directed.create(rawValue: element.attributes[Constant.edgeDefault])

        var vertexes: Set<String> = []
        var edges: Set<EdgeStruct> = []

        for child in element.childElements {
            if child.name == Constant.node {
                if let name = child.attributes[Constant.id] {
                    vertexes.insert(name)
                }
            } else if child.name == Constant.edge {
                if let source = child.attributes[Constant.source] {
                    if let target = child.attributes[Constant.target] {
                        edges.insert(EdgeStruct(source: source, target: target))

                    }
                }
            }
        }
        return Graph(vertices: Array(vertexes), edges: Array(edges), directed: directed)
    }

}
