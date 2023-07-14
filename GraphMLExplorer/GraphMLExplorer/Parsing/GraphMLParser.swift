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
   // func parse(xmlString: String) -> UnweightedGraph<String>
    func parse(xmlString: String) -> MyGraph //UnweightedGraph<String>
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

    func parse(xmlString: String) -> MyGraph { ///UnweightedGraph<String> {
        guard let data = xmlString.data(using: .utf8) else {
            return .empty//emptyGraph
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

    private func setupGraph(from element: XML.Element?) -> MyGraph {//UnweightedGraph<String> { {
        let graph = UnweightedGraph<String>()
        guard let element = element else { return .empty }
        let directed: Directed = Directed.create(rawValue: element.attributes[Constant.edgeDefault])

        // Additional computation, but this graph impl. requires adding vertexes first.

        var vertexes: Set<String> = []
        var edges: Set<EdgeStruct> = []

        for child in element.childElements {
            if child.name == Constant.node {
                if let name = child.attributes[Constant.id] {
//                    if vertexes.firstIndex(of: name) == nil {
//                        //print("3. Adding vertex \(name), directed \(directed.isDirected)")
//                        vertexes.append(name)
//                        _ = graph.addVertex(name)
//                    }
                    //_ = graph.addVertex(name)
                    vertexes.insert(name)
                } else {
                    // throw error?
                }
            } else if child.name == Constant.edge {
                if let source = child.attributes[Constant.source] {
                    if let target = child.attributes[Constant.target] {
                        edges.insert(EdgeStruct(source: source, target: target))
//                        if vertexes.firstIndex(of: source) == nil {
//                            //print("1. Adding vertex source \(source), target \(target), directed \(directed.isDirected)")
//                            vertexes.append(source)
//                            _ = graph.addVertex(source)
//                        }
//                        if vertexes.firstIndex(of: target) == nil {
//                            //print("2. Adding vertex source \(source), target \(target), directed \(directed.isDirected)")
//                            vertexes.append(target)
//                            _ = graph.addVertex(target)
//                        }
 //                       graph.addEdge(from: source, to: target, directed: directed.isDirected)
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
        return MyGraph(vertices: Array(vertexes), edges: Array(edges), directed: directed)
       // return graph
    }

    // Do my own graph impl that does not requires sort?!

}

struct GraphBuilder {
    var vertexes: String
}

struct EdgeStruct: Hashable {
    let source: String
    let target: String
}

struct MyGraph {
    let edges: [EdgeStruct]
    var vertices: [String]
    let directed: Directed

    var edgeCount: Int { edges.count }

    init(vertices: [String], edges: [EdgeStruct], directed: Directed) {
        self.vertices = vertices
        self.edges = edges
        self.directed = directed
    }

    static let empty = MyGraph(vertices: [], edges: [], directed: .undirected)

    func neighborsForVertex(_ vertex: String) -> [String] {
        var neighbors: [String] = []
        for edge in edges {
            if edge.source == vertex {
                neighbors.append(edge.target)
            } else if edge.target == vertex {
                neighbors.append(edge.source)
            }
        }
        return neighbors
    }

    func vertexInGraph(vertex: String) -> Bool {
        vertices.firstIndex(of: vertex) != nil
    }

}

//associatedtype V: Equatable & Codable
//associatedtype E: Edge & Equatable
//var vertices: [V] { get set }
//var edges: [[E]] { get set }
//
//init(vertices: [V])
//func addEdge(_ e: E, directed: Bool)
