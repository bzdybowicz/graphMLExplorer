//
//  Generator.swift
//  GraphMLGenerator
//
//  Created by Bartlomiej Zdybowicz on 10/07/2023.
//

import AppKit
import Foundation
import UniformTypeIdentifiers

protocol GeneratorProtocol {
    func generate()
}

final class Generator: GeneratorProtocol {

    func generate() {
        let document = createDocument()
        let graph = createGraphElement(document: document)
        addKeys(graph: graph)
        addNodes(graph: graph)
        addEdges(graph: graph)
        saveUsingPanel(document: document)
    }

    private func createGraphElement(document: XMLDocument) -> XMLElement {
        var graphml = XMLElement(name: "graphml")
        document.addChild(graphml)
        addNamespace(graphMLElement: graphml)

        let graph = XMLElement(name: "graph")
        graph.setAttributesWith(["id": "G", "edgedefault": "undirected"])
        graphml.addChild(graph)
        return graph
    }

    private func saveUsingPanel(document: XMLDocument) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "xml")].compactMap { $0 }
        panel.begin { [weak self] result in
            if result == NSApplication.ModalResponse.OK, let url = panel.url {
                let data = document.xmlData(options: .nodePrettyPrint)
                self?.saveToFile(fileURL: url, document: document)
            } else {
                print("url \(panel.url), result \(result)")
            }
        }
    }

    private func saveToFile(fileURL: URL, document: XMLDocument) {
        let data = document.xmlData(options: .nodePrettyPrint)
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch let error {
            print("Save file error \(error)")
        }
    }

    private func addNodes(graph: XMLElement) {
        let node = XMLElement()
        node.setAttributesWith(["id": "n0"])
        graph.addChild(node)

        let dataNode = XMLElement(name: "data")
        dataNode.setAttributesWith(["key": "d0"])
        dataNode.stringValue = "Node 1"
        node.addChild(dataNode)
    }

    private func addKeys(graph: XMLElement) {
        let nodeKey = XMLElement(name: "key")
        nodeKey.setAttributesWith(["id": "d0", "for": "node", "attr.name": "label", "attr.type": "string"])
        graph.addChild(nodeKey)

        let edgeKey = XMLElement(name: "key")
        edgeKey.setAttributesWith(["id": "d1", "for": "edge", "attr.name": "weight", "attr.type": "double"])
        graph.addChild(edgeKey)
    }

    private func addEdges(graph: XMLElement) {
        let edge = XMLElement(name: "edge")
        edge.setAttributesWith(["id": "e0", "source": "n0", "target": "n1"])
        graph.addChild(edge)

        let dataEdge = XMLElement(name: "data")
        dataEdge.setAttributesWith(["key": "d1"])
        dataEdge.stringValue = "1.5"
        edge.addChild(dataEdge)
    }

    private func createDocument() -> XMLDocument {
        let document = XMLDocument()

        document.version = "1.0"
        document.characterEncoding = "UTF-8"

        return document
    }

    private func addNamespace(graphMLElement: XMLElement) {
        if let namespace = XMLNode.namespace(withName: "graphml", stringValue: "http://graphml.graphdrawing.org/xmlns") as? XMLNode {
            graphMLElement.addNamespace(namespace)
        }
    }
}
