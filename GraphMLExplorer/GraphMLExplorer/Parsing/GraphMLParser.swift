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

    static func create(graphRawValue: String?) -> Directed {
        guard let graphRawValue = graphRawValue else { return .undirected }
        switch graphRawValue {
        case "true":
            return .directed
        case "false":
            return .undirected
        default:
            return .undirected
        }
    }
}

struct GraphMLParser: GraphMLParserProtocol {

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
            element.name == XMLConstant.graphmlMarker
        }
    }

    private func getGraphElement(element: XML.Element?) -> XML.Element? {
        element?.childElements.first { element in
            element.name == XMLConstant.graphMarker
        }
    }

    private func setupGraph(from element: XML.Element?) -> Graph {
        guard let element = element else {
            return .empty
        }
        let directed: Directed = Directed.create(rawValue: element.attributes[XMLConstant.edgeDefault])

        var vertexes: Set<Vertice> = []
        var edges: Set<EdgeStruct> = []

        for child in element.childElements {
            if child.name == XMLConstant.node {
                if let name = child.attributes[XMLConstant.id] {
                    vertexes.insert(Vertice(id: name))
                }
            } else if child.name == XMLConstant.edge {
                if let source = child.attributes[XMLConstant.source] {
                    if let target = child.attributes[XMLConstant.target] {
                        var childDirected = directed
                        if let childSpecificDirection = child.attributes[XMLConstant.directed] {
                            childDirected = Directed.create(graphRawValue: childSpecificDirection)
                        }
                        edges.insert(EdgeStruct(source: source, target: target, directed: childDirected))
                    }
                }
            }
        }
        return Graph(vertices: vertexes, edges: edges, directed: directed)
    }

}
