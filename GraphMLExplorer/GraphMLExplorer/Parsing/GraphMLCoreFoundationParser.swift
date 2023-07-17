//
//  GraphMLFuziParser.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation

struct GraphMLCoreFoundationParser: GraphMLParserProtocol {

    func parse(xmlString: String) -> Graph {
        TimeMeasure.instance.event(.parserStart)
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

        let graphMLElement = element
        let keys = getKeys(graphMLElement: graphMLElement)
        let graphElement = getGraphElement(element: graphMLElement)
        let graph = keys.isEmpty ? setupGraph(from: graphElement) : setupGraphCustomData(from: graphElement)
        TimeMeasure.instance.event(.parserRestDone)
        return graph
    }

    private func getKeys(graphMLElement: XMLElement?) -> [XMLElement] {
        graphMLElement?.elements(forName: XMLConstant.key) ?? []
    }

    private func getGraphXMLElement(element: XMLElement?) -> XMLElement? {
        element?.elements(forName: XMLConstant.graphmlMarker).first
    }

    private func getGraphElement(element: XMLElement?) -> XMLElement? {
        element?.elements(forName: XMLConstant.graphMarker).first
    }

    private func setupGraph(from element: XMLElement?) -> Graph {
        guard let element = element else { return .empty }
        let directed: Directed = Directed.create(rawValue: element.attribute(forName: XMLConstant.edgeDefault)?.stringValue)
        var vertexes: Set<Vertice> = []
        var edges: Set<EdgeStruct> = []
        let nodes: [XMLNode] = element.children ?? []
        for node in nodes {
            if let child = node as? XMLElement {
                if let name = child.attribute(forName: XMLConstant.id)?.stringValue {
                    vertexes.insert(Vertice(id: name))
                }
                if let source = child.attribute(forName: XMLConstant.source)?.stringValue {
                    if let target = child.attribute(forName: XMLConstant.target)?.stringValue {
                        var childDirected = directed
                        if let directedString = child.attribute(forName: XMLConstant.directed)?.stringValue {
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
        let directed: Directed = Directed.create(rawValue: element.attribute(forName: XMLConstant.edgeDefault)?.stringValue)
        var vertexes: Set<Vertice> = []
        var edges: Set<EdgeStruct> = []
        let nodes: [XMLNode] = element.children ?? []
        for node in nodes {
            if let child = node as? XMLElement {
                if let name = child.attribute(forName: XMLConstant.id)?.stringValue {
                    
                    vertexes.insert(Vertice(id: name))
                }
                if let source = child.attribute(forName: XMLConstant.source)?.stringValue {
                    if let target = child.attribute(forName: XMLConstant.target)?.stringValue {
                        var childDirected = directed
                        if let directedString = child.attribute(forName: XMLConstant.directed)?.stringValue {
                            childDirected = Directed.create(graphRawValue: directedString)
                        }
                        edges.insert(EdgeStruct(source: source, target: target, directed: childDirected))
                    }
                }
            }
        }
        return Graph(vertices: vertexes, edges: edges, directed: directed)
    }

}
