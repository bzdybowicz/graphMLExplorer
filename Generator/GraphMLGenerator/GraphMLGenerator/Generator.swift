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

struct Edge: Equatable, Hashable {
    let source: String
    let target: String
}

final class Generator: GeneratorProtocol {

    private var edgeSet = Set<Edge>()

    func generate(input: GeneratorInput) {
        let document = createDocument()
        let graphML = createGraphMLElement(document: document, input: input)
        addKeys(graph: graphML, input: input)
        let graph = createGraphElement(document: document, graphML: graphML, input: input)
        addNodes(graph: graph, input: input)
        saveUsingPanel(document: document, input: input)
    }
}

private extension Generator {

    func createGraphMLElement(document: XMLDocument, input: GeneratorInput) -> XMLElement {
        let graphml = XMLElement(name: "graphml")
        document.addChild(graphml)
        let headerAttributes = [
            "xmlns": "http://graphml.graphdrawing.org/xmlns",
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "xsi:schemaLocation": "http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd"
        ]
        graphml.setAttributesWith(headerAttributes)
        return graphml
    }

    func createGraphElement(document: XMLDocument, graphML: XMLElement, input: GeneratorInput) -> XMLElement {
        let graph = XMLElement(name: "graph")
        setEdge(graph: graph, input: input)
        graphML.addChild(graph)
        addValuesIfElementKindMatched(parent: graph, input: input)
        return graph
    }

    func setEdge(graph: XMLElement, input: GeneratorInput) {
        graph.setAttributesWith(["id": "G", "edgedefault": input.edgeDefault.xmlValue])
    }

    func saveUsingPanel(document: XMLDocument, input: GeneratorInput) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "xml")].compactMap { $0 }
        panel.nameFieldStringValue = input.numberOfNodesInput + "edgeMin" + "\(input.edgesInputMin)" + "edgeMax" + "\(input.edgesInputMax)"
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
        for i in 0..<input.numberOfNodes {
            let node = XMLElement()
            node.name = "node"
            let id = "n\(i)"
            node.setAttributesWith(["id": id])
            addEdges(graph: graph, sourceId: id, input: input)
            graph.addChild(node)
            addValuesIfElementKindMatched(parent: node, input: input)
        }
    }

    func addValuesIfElementKindMatched(parent: XMLElement, input: GeneratorInput) {
        for (index, customData) in input.customDataArray.enumerated() {
            let element = XMLElement(name: "data")
            addValueIfElementKindMatched(element: element, customData: customData, elementKind: .node)
            element.setAttributesWith(["key": "d\(index)"])
            parent.addChild(element)
        }
    }

    func addValueIfElementKindMatched(element: XMLElement, customData: CustomData, elementKind: AttributeValueKind) {
        var value: String
        if customData.elementKind == elementKind || customData.elementKind == .all {
            switch customData.dataType {
            case .boolean:
                value = "\(Bool.random())"
            case .double:
                value = "\(Double.random(in: 0..<Double.greatestFiniteMagnitude))"
            case .float:
                value = "\(Float.random(in: 0..<Float.greatestFiniteMagnitude))"
            case .int:
                value = "\(Int.random(in: 0..<Int.max))"
            case .long:
                value = "\(Int64.random(in: 0..<Int64.max))"
            case .string:
                let values = ["orange", "blue", "red", "magenta", "yellow", "white", "black"]
                value = values.randomElement()!
            }
            element.stringValue = value
        }
    }

    func addKeys(graph: XMLElement, input: GeneratorInput) {
        let array = Array(input.customDataArray)
        for (index, customData) in array.enumerated() {
            let element = XMLElement(name: "key")
            let customDataName = customData.name.isEmpty ? "customData\(index)" : customData.name
            element.setAttributesWith(["id" : "d\(index)",
                                       "for": customData.elementKind.rawValue,
                                       "attr.type": customData.dataType.rawValue,
                                       "attr.name": customDataName])
            graph.addChild(element)
        }
    }

    func addEdges(graph: XMLElement, sourceId: String, input: GeneratorInput) {
        for _ in 0...input.edgesPerNode {
            let edgeElement = XMLElement(name: "edge")
            let maxNode = input.numberOfNodes
            let targetInt = (Int.random(in: 0..<maxNode))
            let targetString = "n\(targetInt)"
            var attributes = ["source": sourceId, "target": targetString]

            let edge = Edge(source: sourceId, target: targetString)
            if edgeSet.contains(edge) || (input.edgeDefault == .undirected && edgeSet.contains(Edge(source: targetString, target: sourceId))) {
                // No duplicates.
                continue
            }
            edgeSet.insert(edge)
            if input.edgeDefault == .mixed {
                attributes["directed"] = String(Bool.random())
            }
            edgeElement.setAttributesWith(attributes)
            addValuesIfElementKindMatched(parent: edgeElement, input: input)
            graph.addChild(edgeElement)
        }
    }

    func createDocument() -> XMLDocument {
        let document = XMLDocument()

        document.version = "1.0"
        document.characterEncoding = "UTF-8"

        return document
    }

}
