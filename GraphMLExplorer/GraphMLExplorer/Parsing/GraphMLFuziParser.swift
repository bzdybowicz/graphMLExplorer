//
//  GraphMLFuziParser2.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation
import Fuzi

struct GraphMLFuziParser: GraphMLParserProtocol {

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
        TimeMeasure.instance.event(.parserStart)
        var document: Fuzi.XMLDocument?
        do {
            document = try XMLDocument(string: xmlString, encoding: .utf8)
        } catch let error {
            print("Parsing error \(error)")
        }
        guard let element = document?.root else {
            return .empty
        }
        TimeMeasure.instance.event(.parserXMLDone)

        let graphMLElement = getGraphXMLElement(element: element)
        let graphElement = getGraphElement(element: graphMLElement)
        let graph = setupGraph(from: graphElement)
        TimeMeasure.instance.event(.parserRestDone)
        return graph
    }

    private func getGraphXMLElement(element: Fuzi.XMLElement?) -> Fuzi.XMLElement? {
        element
    }

    private func getGraphElement(element: Fuzi.XMLElement?) -> Fuzi.XMLElement? {
        element?.firstChild(tag: Constant.graphMarker)

    }

    private func setupGraph(from element: Fuzi.XMLElement?) -> Graph {
        guard let element = element else { return .empty }
        let directed: Directed = Directed.create(rawValue: element.attributes[Constant.edgeDefault])

        var vertexes: Set<String> = []
        var edges: Set<EdgeStruct> = []

        for child in element.children {
            if child.tag == Constant.node {
                if let name = child.attributes[Constant.id] {
                    vertexes.insert(name)
                }
            } else if child.tag == Constant.edge {
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
