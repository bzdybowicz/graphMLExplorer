//
//  BZGraph.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation

enum DataType: String, CaseIterable {
    case boolean
    case int
    case long
    case float
    case double
    case string
    case unknown

    static func create(xmlString: String?) -> DataType {
        guard let xmlString = xmlString else { return .unknown}
        return DataType(rawValue: xmlString) ?? .unknown
    }
}

struct GraphCustomData: Equatable, Comparable, Hashable  {
    static func < (lhs: GraphCustomData, rhs: GraphCustomData) -> Bool {
        guard let lvalue = lhs.value else {
            return true
        }
        guard let rvalue = rhs.value else {
            return false
        }
        return lvalue < rvalue
    }

    let key: String
    let dataName: String?
    let value: String?
    let valueDataType: DataType?
}

struct Vertice: Equatable, Comparable, Hashable {
    static func < (lhs: Vertice, rhs: Vertice) -> Bool {
        lhs.id < rhs.id
    }

    let id: String
    let data: [GraphCustomData]

    init(id: String, data: [GraphCustomData] = []) {
        self.id = id
        self.data = data
    }
}

struct Graph {

    static let empty = Graph(vertices: [], edges: [], directed: .undirected)
    let edges: Set<EdgeStruct>
    var vertices: Set<Vertice>
    let directed: Directed
    let graphCustomData: [GraphCustomData]
    var edgeCount: Int { edges.count }

    init(vertices: Set<Vertice>, edges: Set<EdgeStruct>, directed: Directed, graphCustomData: [GraphCustomData] = []) {
        self.vertices = vertices
        self.edges = edges
        self.directed = directed
        self.graphCustomData = graphCustomData
    }

    func neighborsForVertex(_ vertice: Vertice) -> Set<Vertice> {
        var neighbors: Set<Vertice> = []
        for edge in edges {
            if edge.source == vertice.id {
                if let vertice = (vertices.first { $0.id == edge.target }) {
                    neighbors.insert(vertice)
                }
            } else if edge.target == vertice.id && edge.directed == .undirected {
                if let vertice = (vertices.first { $0.id == edge.source}) {
                    neighbors.insert(vertice)
                }
            }
        }
        return neighbors
    }

    func vertexInGraph(vertice: Vertice) -> Bool {
        vertices.firstIndex { $0.id == vertice.id } != nil
    }

}

struct EdgeStruct: Hashable {
    let source: String
    let target: String
    let directed: Directed
    let graphCustomData: [GraphCustomData]

    init(source: String, target: String, directed: Directed, graphCustomData: [GraphCustomData] = []) {
        self.source = source
        self.target = target
        self.directed = directed
        self.graphCustomData = graphCustomData
    }
}
