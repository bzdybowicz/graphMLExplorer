//
//  GraphMLFuziParser.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation

struct GraphMLFoundationParser: GraphMLParserProtocol {

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
        // Prevent multiple condition checks for no reason.
        let graph = keys.isEmpty ? setupGraph(from: graphElement) : setupGraphCustomData(from: graphElement, keys: keys)
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
        guard let element = element else {
            return .empty
        }
        let directed: Directed = Directed.create(rawValue: element.attribute(forName: XMLConstant.edgeDefault)?.stringValue)
        var vertexes: Set<Vertice> = []
        var edges: Set<EdgeStruct> = []
        var hyperEdges: Set<HyperEdge> = []
        var hyperIndex = 0
        let nodes: [XMLNode] = element.children ?? []
        for node in nodes {
            if let child = node as? XMLElement {
                if child.name == XMLConstant.node, let name = child.attribute(forName: XMLConstant.id)?.stringValue {
                    vertexes.insert(Vertice(id: name, ports: ports(element: child)))
                } else if child.name == XMLConstant.edge, let source = child.attribute(forName: XMLConstant.source)?.stringValue {
                    if let target = child.attribute(forName: XMLConstant.target)?.stringValue {
                        var childDirected = directed
                        if let directedString = child.attribute(forName: XMLConstant.directed)?.stringValue {
                            childDirected = Directed.create(rawValue: directedString)
                        }
                        var edgeSourcePort: Port?
                        var edgeTargetPort: Port?
                        if let sourcePortString = child.attribute(forName: XMLConstant.sourcePort)?.stringValue {
                            edgeSourcePort = Port(name: sourcePortString)
                        }
                        if let edgeTargetString = child.attribute(forName: XMLConstant.targetPort)?.stringValue {
                            edgeTargetPort = Port(name: edgeTargetString)
                        }
                        edges.insert(EdgeStruct(source: source,
                                                target: target,
                                                directed: childDirected,
                                                sourcePort: edgeSourcePort,
                                                targetPort: edgeTargetPort))
                    }
                } else if child.name == XMLConstant.hyperEdge {
                    var nodes: Set<HyperedgeNode> = []
                    for childOfChild in child.elements(forName: XMLConstant.endpoint) {
                        var childNodeName: String = ""
                        var port: Port?
                        if let node = childOfChild.attribute(forName: XMLConstant.node)?.stringValue {
                            childNodeName = node
                        }
                        if let portName = childOfChild.attribute(forName: XMLConstant.port)?.stringValue {
                            port = Port(name: portName)
                        }
                        nodes.insert(HyperedgeNode(id: childNodeName, port: port))
                    }
                    hyperEdges.insert(HyperEdge(nodes: nodes, index: hyperIndex))
                    hyperIndex += 1
                }
            }
        }
        return Graph(vertices: vertexes, edges: edges, directed: directed, hyperEdges: hyperEdges)
    }

    private func setupGraphCustomData(from element: XMLElement?, keys: [XMLElement]) -> Graph {
        guard let element = element else { return .empty }
        let directed: Directed = Directed.create(rawValue: element.attribute(forName: XMLConstant.edgeDefault)?.stringValue)
        var vertexes: Set<Vertice> = []
        var edges: Set<EdgeStruct> = []
        let nodes: [XMLNode] = element.children ?? []
        var customDataTemplate: [String: GraphCustomData] = [:]
        for key in keys {
            let name = key.attribute(forName: XMLConstant.attrName)?.stringValue
            let type = key.attribute(forName: XMLConstant.attrType)?.stringValue
            if let id = key.attribute(forName: XMLConstant.id)?.stringValue {
                customDataTemplate[id] = (GraphCustomData(key: id,
                                                          dataName: name,
                                                          value: nil,
                                                          valueDataType: DataType.create(xmlString: type)))
            }
        }
        for node in nodes {
            if let child = node as? XMLElement {
                if let name = child.attribute(forName: XMLConstant.id)?.stringValue {
                    vertexes.insert(Vertice(id: name, data: customData(element: child,
                                                                       customDataTemplate: customDataTemplate),
                                            ports: ports(element: child)))
                }
                if let source = child.attribute(forName: XMLConstant.source)?.stringValue {
                    if let target = child.attribute(forName: XMLConstant.target)?.stringValue {
                        var childDirected = directed
                        if let directedString = child.attribute(forName: XMLConstant.directed)?.stringValue {
                            childDirected = Directed.create(graphRawValue: directedString)
                        }
                        var edgeSourcePort: Port?
                        var edgeTargetPort: Port?
                        if let sourcePortString = child.attribute(forName: XMLConstant.sourcePort)?.stringValue {
                            edgeSourcePort = Port(name: sourcePortString)
                        }
                        if let edgeTargetString = child.attribute(forName: XMLConstant.targetPort)?.stringValue {
                            edgeTargetPort = Port(name: edgeTargetString)
                        }
                        edges.insert(EdgeStruct(source: source,
                                                target: target,
                                                directed: childDirected,
                                                graphCustomData: customData(element: child,
                                                                            customDataTemplate: customDataTemplate),
                                                sourcePort: edgeSourcePort,
                                                targetPort: edgeTargetPort))
                    }
                }
            }
        }
        return Graph(vertices: vertexes,
                     edges: edges,
                     directed: directed,
                     graphCustomData: customData(element: element,
                                                 customDataTemplate: customDataTemplate))
    }

    private func ports(element: XMLElement) -> Set<Port> {
        var ports: Set<Port> = []
        for dataChild in element.elements(forName: XMLConstant.port) {
            if let name = dataChild.attribute(forName: XMLConstant.name)?.stringValue {
                ports.insert(Port(name: name))
            }
        }
        return ports
    }

    private func customData(element: XMLElement, customDataTemplate: [String: GraphCustomData]) -> [GraphCustomData] {
        var customData: [GraphCustomData] = []
        for dataChild in element.elements(forName: XMLConstant.data) {
            if let key = dataChild.attribute(forName: XMLConstant.key)?.stringValue {
                let template = customDataTemplate[key]
                customData.append(GraphCustomData(key: key,
                                                  dataName: template?.dataName,
                                                  value: dataChild.stringValue,
                                                  valueDataType: template?.valueDataType))
            }
        }
        return customData
    }

}
