//
//  GraphMLParser.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 05/07/2023.
//

import Foundation
import SwiftyXMLParser
import SwiftGraph

protocol GraphMLParserProtocol {
    func parse(xmlString: String) -> UnweightedGraph<String>
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

    private let emptyGraph = UnweightedGraph<String>()

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

    func parse(xmlString: String) -> UnweightedGraph<String> {
        guard let data = xmlString.data(using: .utf8) else {
            return emptyGraph
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
        return emptyGraph
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

    private func setupGraph(from element: XML.Element?) -> UnweightedGraph<String> {
        let graph = UnweightedGraph<String>()
        guard let element = element else { return graph }
        let directed: Directed = Directed.create(rawValue: element.attributes[Constant.edgeDefault])

        // Additional computation, but this graph impl. requires adding vertexes first.

        var vertexes: [String] = []

        print("1. VERTICES COUNT \(graph.vertices.count) \(graph.vertexCount)")

        for child in element.childElements {
            if child.name == Constant.node {
                if let name = child.attributes[Constant.id] {
                    if vertexes.firstIndex(of: name) == nil {
                        //print("3. Adding vertex \(name), directed \(directed.isDirected)")
                        vertexes.append(name)
                        _ = graph.addVertex(name)
                    }
                    //_ = graph.addVertex(name)
                } else {
                    // throw error?
                }
            } else if child.name == Constant.edge {
                if let source = child.attributes[Constant.source] {
                    if let target = child.attributes[Constant.target] {
                        if vertexes.firstIndex(of: source) == nil {
                            //print("1. Adding vertex source \(source), target \(target), directed \(directed.isDirected)")
                            vertexes.append(source)
                            _ = graph.addVertex(source)
                        }
                        if vertexes.firstIndex(of: target) == nil {
                            //print("2. Adding vertex source \(source), target \(target), directed \(directed.isDirected)")
                            vertexes.append(target)
                            _ = graph.addVertex(target)
                        }
                        graph.addEdge(from: source, to: target, directed: directed.isDirected)
                    } else {
                        // not sure yet
                    }
                }
            }
        }
//        for vertex in vertexes {
//            print("VERTEX\(vertex)")
//        }
//        for vertex in graph.vertices {
//            print("VERTICE \(vertex)")
//        }
        print("2. VERTICES COUNT \(graph.vertices.count) \(graph.vertexCount)")
        return graph
    }

    // Do my own graph impl that does not requires sort?!

}
