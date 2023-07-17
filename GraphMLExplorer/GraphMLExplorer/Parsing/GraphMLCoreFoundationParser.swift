//
//  GraphMLFuziParser.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation

struct GraphMLCoreFoundationParser: GraphMLParserProtocol {

    private enum Constant {
        static let graphmlMarker = "graphml"
        static let graphMarker = "graph"
        static let node = "node"
        static let edge = "edge"
        static let target = "target"
        static let source = "source"
        static let directed = "directed"
        static let key = "key"
        static let edgeDefault = "edgedefault"
        static let id = "id"
    }

    func parse(xmlString: String) -> Graph {
        guard let data = xmlString.data(using: .utf8) else {
            return .empty
        }
        TimeMeasure.instance.event(.parserStart)
        //let xml = XML.parse(data)
        var document: XMLDocument?
        do {
            document = try XMLDocument(xmlString: xmlString)
        } catch let error {
            print("Parsing error \(error)")
        }
        guard let element = document?.rootElement() else {
            return .empty
        }
        TimeMeasure.instance.event(.parserXMLDone)

        let graphMLElement = element //getGraphXMLElement(element: element)
        let keys = getKeys(graphMLElement: graphMLElement)
        let graphElement = getGraphElement(element: graphMLElement)
        let graph = keys.isEmpty ? setupGraph(from: graphElement) : setupGraphCustomData(from: graphElement)
        TimeMeasure.instance.event(.parserRestDone)
        return graph
    }

    private func getKeys(graphMLElement: XMLElement?) -> [XMLElement] {
        graphMLElement?.elements(forName: Constant.key) ?? []
    }

    private func getGraphXMLElement(element: XMLElement?) -> XMLElement? {
        element?.elements(forName: Constant.graphmlMarker).first
    }

    private func getGraphElement(element: XMLElement?) -> XMLElement? {
        element?.elements(forName: Constant.graphMarker).first
    }

    private func setupGraph(from element: XMLElement?) -> Graph {
        guard let element = element else { return .empty }
        let directed: Directed = Directed.create(rawValue: element.attribute(forName: Constant.edgeDefault)?.stringValue)
        var vertexes: Set<Vertice> = []
        var edges: Set<EdgeStruct> = []
        let nodes: [XMLNode] = element.children ?? []
        for node in nodes {
            if let child = node as? XMLElement {
                if let name = child.attribute(forName: Constant.id)?.stringValue {
                    vertexes.insert(Vertice(id: name))
                }
                if let source = child.attribute(forName: Constant.source)?.stringValue {
                    if let target = child.attribute(forName: Constant.target)?.stringValue {
                        var childDirected = directed
                        if let directedString = child.attribute(forName: Constant.directed)?.stringValue {
                            childDirected = Directed.create(rawValue: directedString)
                        }
                        edges.insert(EdgeStruct(source: source, target: target, directed: childDirected))
                    }
                }
            }
        }
        return Graph(vertices: vertexes, edges: edges, directed: directed)
    }

    private func setupGraphCustomData(from element: XMLElement?) -> Graph {
        guard let element = element else { return .empty }
        let directed: Directed = Directed.create(rawValue: element.attribute(forName: Constant.edgeDefault)?.stringValue)
        var vertexes: Set<Vertice> = []
        var edges: Set<EdgeStruct> = []
        let nodes: [XMLNode] = element.children ?? []
        for node in nodes {
            if let child = node as? XMLElement {
                if let name = child.attribute(forName: Constant.id)?.stringValue {
                    
                    vertexes.insert(Vertice(id: name))
                }
                if let source = child.attribute(forName: Constant.source)?.stringValue {
                    if let target = child.attribute(forName: Constant.target)?.stringValue {
                        var childDirected = directed
                        if let directedString = child.attribute(forName: Constant.directed)?.stringValue {
                            childDirected = Directed.create(rawValue: directedString)
                        }
                        edges.insert(EdgeStruct(source: source, target: target, directed: childDirected))
                    }
                }
            }
        }
        return Graph(vertices: vertexes, edges: edges, directed: directed)
    }

}
