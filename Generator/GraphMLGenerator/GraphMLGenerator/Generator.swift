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
    func generate(input: GeneratorInput)
}

final class Generator: GeneratorProtocol {

    private var nodes: [XMLElement] = []

    func generate(input: GeneratorInput) {
        print("Input number of nodes \(input.numberOfNodes)")
        let document = createDocument()
        var graph = createGraphElement(document: document)
        //addKeys(graph: graph)
        addNodes(graph: graph, input: input)
        saveUsingPanel(document: document, input: input)
    }
}

private extension Generator {
    func createGraphElement(document: XMLDocument) -> XMLElement {
        let graphml = XMLElement(name: "graphml")
        document.addChild(graphml)
        let headerAttributes = [
            "xmlns": "http://graphml.graphdrawing.org/xmlns",
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "xsi:schemaLocation": "http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd"
        ]
        graphml.setAttributesWith(headerAttributes)

        let graph = XMLElement(name: "graph")
        graph.setAttributesWith(["id": "G", "edgedefault": "undirected"])
        graphml.addChild(graph)
        return graph
    }

    func saveUsingPanel(document: XMLDocument, input: GeneratorInput) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "xml")].compactMap { $0 }
        panel.nameFieldStringValue = input.numberOfNodesInput
        panel.begin { [weak self] result in
            if result == NSApplication.ModalResponse.OK, let url = panel.url {
                print("Document \(document)")
                self?.saveToFile(fileURL: url, document: document)
            } else {
                print("url \(String(describing: panel.url)), result \(result)")
            }
        }
    }

    func saveToFile(fileURL: URL, document: XMLDocument) {
        let data = document.xmlData(options: .nodePrettyPrint)
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch let error {
            print("Save file error \(error)")
        }
    }

    func addNodes(graph: XMLElement, input: GeneratorInput) {
//        let node = XMLElement()
//        node.setAttributesWith(["id": "n0"])
//        node.name = "node"
//        graph.addChild(node)
//
//        let dataNode = XMLElement(name: "data")
//        dataNode.setAttributesWith(["key": "d0"])
//        dataNode.stringValue = "Node 1"
//        node.addChild(dataNode)

        for i in 0..<input.numberOfNodes {
            let node = XMLElement()
            nodes.append(node)
            node.name = "node"
            let id = "n\(i)"
            node.setAttributesWith(["id": id])
            //node.stringValue = id
            addEdges(graph: graph, sourceId: id, input: input)
            graph.addChild(node)
//            let dataNode = XMLElement(name: "data")
//            dataNode.setAttributesWith(["key": "d0"])
//            dataNode.stringValue = "Node \(i)"
//            node.addChild(dataNode)
        }
    }

    func addKeys(graph: XMLElement) {
        let nodeKey = XMLElement(name: "key")
        nodeKey.setAttributesWith(["id": "d0", "for": "node", "attr.name": "label", "attr.type": "string"])
        graph.addChild(nodeKey)

        let edgeKey = XMLElement(name: "key")
        edgeKey.setAttributesWith(["id": "d1", "for": "edge", "attr.name": "weight", "attr.type": "double"])
        graph.addChild(edgeKey)
    }

    func addEdges(graph: XMLElement, sourceId: String, input: GeneratorInput) {
        print("edges input \(input.edgesPerNode)")

        for _ in 0...input.edgesPerNode {
            let edge = XMLElement(name: "edge")
            let maxNode = input.numberOfNodes
            let targetInt = (Int.random(in: 0..<maxNode))
            let targetString = "n\(targetInt)"
            edge.setAttributesWith(["source": sourceId, "target": targetString])
            graph.addChild(edge)
        }

//        let edge = XMLElement(name: "edge")
//        edge.setAttributesWith(["id": "e0", "source": "n0", "target": "n1"])
//        graph.addChild(edge)
//
//        let dataEdge = XMLElement(name: "data")
//        dataEdge.setAttributesWith(["key": "d1"])
//        dataEdge.stringValue = "1.5"
//        edge.addChild(dataEdge)
    }

    func createDocument() -> XMLDocument {
        let document = XMLDocument()

        document.version = "1.0"
        document.characterEncoding = "UTF-8"

        return document
    }

}
