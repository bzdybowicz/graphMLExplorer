//
//  GraphMLFuziParser2.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation
import Fuzi

struct GraphMLFuziParser: GraphMLParserProtocol {

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
        element?.firstChild(tag: XMLConstant.graphMarker)

    }

    private func setupGraph(from element: Fuzi.XMLElement?) -> Graph {
        guard let element = element else { return .empty }
        let directed: Directed = Directed.create(rawValue: element.attributes[XMLConstant.edgeDefault])

        var vertexes: Set<Vertice> = []
        var edges: Set<EdgeStruct> = []

        for child in element.children {
            if child.tag == XMLConstant.node {
                if let name = child.attributes[XMLConstant.id] {
                    vertexes.insert(Vertice(id: name))
                }
            } else if child.tag == XMLConstant.edge {
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
