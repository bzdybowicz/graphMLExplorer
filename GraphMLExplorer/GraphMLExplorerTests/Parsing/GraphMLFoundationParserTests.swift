//
//  GraphMLFoundationParserTests.swift
//  GraphMLExplorerTests
//
//  Created by Bartlomiej Zdybowicz on 16/07/2023.
//

import Foundation
@testable import GraphMLExplorer
import XCTest

final class GraphMLFoundationParserTests: XCTestCase {

    func testParseUndirected11nodes13edges() {
        let sut = GraphMLFoundationParser()
        let sampleString =
"""
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\"  \n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns\n     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">\n  <graph id=\"G\" edgedefault=\"undirected\">\n    <node id=\"n0\"/>\n    <node id=\"n1\"/>\n    <node id=\"n2\"/>\n    <node id=\"n3\"/>\n    <node id=\"n4\"/>\n    <node id=\"n5\"/>\n    <node id=\"n6\"/>\n    <node id=\"n7\"/>\n    <node id=\"n8\"/>\n    <node id=\"n9\"/>\n    <node id=\"n10\"/>\n    <edge source=\"n0\" target=\"n2\"/>\n    <edge source=\"n0\" target=\"n1\"/>\n    <edge source=\"n1\" target=\"n2\"/>\n    <edge source=\"n2\" target=\"n3\"/>\n    <edge source=\"n3\" target=\"n5\"/>\n    <edge source=\"n3\" target=\"n4\"/>\n    <edge source=\"n4\" target=\"n6\"/>\n    <edge source=\"n6\" target=\"n5\"/>\n    <edge source=\"n5\" target=\"n7\"/>\n    <edge source=\"n6\" target=\"n8\"/>\n    <edge source=\"n8\" target=\"n7\"/>\n    <edge source=\"n8\" target=\"n9\"/>\n    <edge source=\"n8\" target=\"n10\"/>\n  </graph>\n</graphml>
"""
        let graph = sut.parse(xmlString: sampleString)
        let expectedVertices: Set<Vertice> = Set(["n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "n9", "n10"].map { Vertice(id: $0) })
        let expectedEdges: Set<EdgeStruct> = [EdgeStruct(source: "n0", target: "n1", directed: .undirected),
                                              EdgeStruct(source: "n0", target: "n2", directed: .undirected),
                                              EdgeStruct(source: "n1", target: "n2", directed: .undirected),
                                              EdgeStruct(source: "n2", target: "n3", directed: .undirected),
                                              EdgeStruct(source: "n3", target: "n5", directed: .undirected),
                                              EdgeStruct(source: "n3", target: "n4", directed: .undirected),
                                              EdgeStruct(source: "n4", target: "n6", directed: .undirected),
                                              EdgeStruct(source: "n6", target: "n5", directed: .undirected),
                                              EdgeStruct(source: "n5", target: "n7", directed: .undirected),
                                              EdgeStruct(source: "n6", target: "n8", directed: .undirected),
                                              EdgeStruct(source: "n8", target: "n7", directed: .undirected),
                                              EdgeStruct(source: "n8", target: "n9", directed: .undirected),
                                              EdgeStruct(source: "n8", target: "n10", directed: .undirected)]
        XCTAssertEqual(graph, Graph(vertices: expectedVertices, edges: expectedEdges, directed: .undirected))
    }

    func testParseDirected10vertices11edges() {
        let sut = GraphMLFoundationParser()
        let sampleString =
"""
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\"  \n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns\n     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">\n  <graph id=\"G\" edgedefault=\"directed\">\n    <node id=\"n0\"/>\n    <node id=\"n1\"/>\n    <node id=\"n2\"/>\n    <node id=\"n3\"/>\n    <node id=\"n4\"/>\n    <node id=\"n5\"/>\n    <node id=\"n6\"/>\n    <node id=\"n8\"/>\n    <node id=\"n9\"/>\n    <node id=\"n10\"/>\n    <edge source=\"n0\" target=\"n2\"/>\n    <edge source=\"n0\" target=\"n1\"/>\n    <edge source=\"n1\" target=\"n2\"/>\n    <edge source=\"n2\" target=\"n3\"/>\n    <edge source=\"n3\" target=\"n5\"/>\n    <edge source=\"n3\" target=\"n4\"/>\n    <edge source=\"n4\" target=\"n6\"/>\n    <edge source=\"n6\" target=\"n5\"/>\n    <edge source=\"n6\" target=\"n8\"/>\n   <edge source=\"n8\" target=\"n9\"/>\n    <edge source=\"n8\" target=\"n10\"/>\n  </graph>\n</graphml>
"""
        let graph = sut.parse(xmlString: sampleString)
        let expectedVertices: Set<Vertice> = Set(["n0", "n1", "n2", "n3", "n4", "n5", "n6", "n8", "n9", "n10"].map { Vertice(id: $0) })
        let expectedEdges: Set<EdgeStruct> = [EdgeStruct(source: "n0", target: "n1", directed: .directed),
                                              EdgeStruct(source: "n0", target: "n2", directed: .directed),
                                              EdgeStruct(source: "n1", target: "n2", directed: .directed),
                                              EdgeStruct(source: "n2", target: "n3", directed: .directed),
                                              EdgeStruct(source: "n3", target: "n5", directed: .directed),
                                              EdgeStruct(source: "n3", target: "n4", directed: .directed),
                                              EdgeStruct(source: "n4", target: "n6", directed: .directed),
                                              EdgeStruct(source: "n6", target: "n5", directed: .directed),
                                              EdgeStruct(source: "n6", target: "n8", directed: .directed),
                                              EdgeStruct(source: "n8", target: "n9", directed: .directed),
                                              EdgeStruct(source: "n8", target: "n10", directed: .directed)]
        XCTAssertEqual(graph, Graph(vertices: expectedVertices, edges: expectedEdges, directed: .directed))
    }

    func testParseHyperEdgeGraph() {
        let hyperEdgeGraph =
"""
<?xml version="1.0" encoding="UTF-8"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">
  <graph id="G" edgedefault="undirected">
    <node id="n0"/>
    <node id="n1"/>
    <node id="n2"/>
    <node id="n3"/>
    <node id="n4"/>
    <node id="n5"/>
    <node id="n6"/>
    <hyperedge>
       <endpoint node="n0"/>
       <endpoint node="n1"/>
       <endpoint node="n2"/>
     </hyperedge>
    <hyperedge>
       <endpoint node="n3"/>
       <endpoint node="n4"/>
       <endpoint node="n5"/>
       <endpoint node="n6"/>
     </hyperedge>
    <hyperedge>
       <endpoint node="n1"/>
       <endpoint node="n3"/>
     </hyperedge>
    <edge source="n0" target="n4"/>
  </graph>
</graphml>
"""
        let sut = GraphMLFoundationParser()
        let graph = sut.parse(xmlString: hyperEdgeGraph)
        let vertices: Set<Vertice> = Set(["n0", "n1", "n2", "n3", "n4", "n5", "n6"].map { Vertice(id: $0) })
        let edges: Set<EdgeStruct> = [EdgeStruct(source: "n0", target: "n4", directed: .undirected)]
        XCTAssertEqual(graph, Graph(vertices: vertices,
                                    edges: edges,
                                    directed: .undirected,
                                    hyperEdges: [HyperEdge(nodes: [HyperedgeNode(id: "n0"),
                                                                   HyperedgeNode(id: "n1"),
                                                                   HyperedgeNode(id: "n2")],
                                                           index: 0),
                                                 HyperEdge(nodes: [HyperedgeNode(id: "n3"),
                                                                   HyperedgeNode(id: "n4"),
                                                                   HyperedgeNode(id: "n5"),
                                                                   HyperedgeNode(id: "n6")],
                                                           index: 1),
                                                 HyperEdge(nodes: [HyperedgeNode(id: "n1"),
                                                                   HyperedgeNode(id: "n3")],
                                                           index: 2)]))
    }

    func testGraphWithPorts() {
        let graphString =
        """
<?xml version="1.0" encoding="UTF-8"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">
  <graph id="G" edgedefault="directed">
    <node id="n0">
      <port name="North"/>
      <port name="South"/>
      <port name="East"/>
      <port name="West"/>
    </node>
    <node id="n1">
      <port name="North"/>
      <port name="South"/>
      <port name="East"/>
      <port name="West"/>
    </node>
    <node id="n2">
      <port name="NorthWest"/>
      <port name="SouthEast"/>
    </node>
    <node id="n3">
      <port name="NorthEast"/>
      <port name="SouthWest"/>
    </node>
    <edge source="n0" target="n3" sourceport="North" targetport="NorthEast"/>
    <hyperedge>
       <endpoint node="n0" port="North"/>
       <endpoint node="n1" port="East"/>
       <endpoint node="n2" port="SouthEast"/>
     </hyperedge>
  </graph>
</graphml>
"""
        let sut = GraphMLFoundationParser()
        let graph = sut.parse(xmlString: graphString)
        let vertices: Set<Vertice> = [
            Vertice(id: "n0", ports: [Port(name: "North"), Port(name: "South"), Port(name: "East"), Port(name: "West")]),
            Vertice(id: "n1", ports: [Port(name: "North"), Port(name: "South"), Port(name: "East"), Port(name: "West")]),
            Vertice(id: "n2", ports: [Port(name: "NorthWest"), Port(name: "SouthEast")]),
            Vertice(id: "n3", ports: [Port(name: "NorthEast"), Port(name: "SouthWest")]),
        ]
        let edges: Set<EdgeStruct> = [
            EdgeStruct(source: "n0",
                       target: "n3",
                       directed: .directed,
                       sourcePort: Port(name: "North"),
                       targetPort: Port(name: "NorthEast"))
            ]
        let hyperEdges: Set<HyperEdge> = [HyperEdge(nodes: [HyperedgeNode(id: "n0", port: Port(name: "North")),
                                                            HyperedgeNode(id: "n1", port: Port(name: "East")),
                                                            HyperedgeNode(id: "n2", port: Port(name: "SouthEast"))],
                                                    index: 0)]
        XCTAssertEqual(graph, Graph(vertices: vertices, edges: edges, directed: .directed, hyperEdges: hyperEdges))
    }

    func testGraphWithIdsInEdges() {
        let graphString =
"""
<?xml version="1.0" encoding="UTF-8"?>
<!-- This file was written by the JAVA GraphML Library.-->
<graphml xmlns="http://graphml.graphdrawing.org/xmlns"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns
                                http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">
  <graph id="G" edgedefault="directed"
            parse.nodes="11" parse.edges="12"
            parse.maxindegree="2" parse.maxoutdegree="3"
            parse.nodeids="canonical" parse.edgeids="free"
            parse.order="nodesfirst">
    <node id="n0" parse.indegree="0" parse.outdegree="1"/>
    <node id="n1" parse.indegree="0" parse.outdegree="1"/>
    <node id="n2" parse.indegree="2" parse.outdegree="1"/>
    <node id="n3" parse.indegree="1" parse.outdegree="2"/>
    <node id="n4" parse.indegree="1" parse.outdegree="1"/>
    <node id="n5" parse.indegree="2" parse.outdegree="1"/>
    <node id="n6" parse.indegree="1" parse.outdegree="2"/>
    <node id="n7" parse.indegree="2" parse.outdegree="0"/>
    <node id="n8" parse.indegree="1" parse.outdegree="3"/>
    <node id="n9" parse.indegree="1" parse.outdegree="0"/>
    <node id="n10" parse.indegree="1" parse.outdegree="0"/>
    <edge id="edge0001" source="n0" target="n2"/>
    <edge id="edge0002" source="n1" target="n2"/>
    <edge id="edge0003" source="n2" target="n3"/>
    <edge id="edge0004" source="n3" target="n5"/>
    <edge id="edge0005" source="n3" target="n4"/>
    <edge id="edge0006" source="n4" target="n6"/>
    <edge id="edge0007" source="n6" target="n5"/>
    <edge id="edge0008" source="n5" target="n7"/>
    <edge id="edge0009" source="n6" target="n8"/>
    <edge id="edge0010" source="n8" target="n7"/>
    <edge id="edge0011" source="n8" target="n9"/>
    <edge id="edge0012" source="n8" target="n10"/>
  </graph>
</graphml>
"""
        let sut = GraphMLFoundationParser()
        let vertices: Set<Vertice> = Set(["n0","n1","n2","n3","n4","n5","n6","n7","n8","n9","n10"].map { Vertice(id: $0) })
        let edges: Set<EdgeStruct> = [
            EdgeStruct(source: "n0", target: "n2", directed: .directed),
            EdgeStruct(source: "n1", target: "n2", directed: .directed),
            EdgeStruct(source: "n2", target: "n3", directed: .directed),
            EdgeStruct(source: "n3", target: "n5", directed: .directed),
            EdgeStruct(source: "n3", target: "n4", directed: .directed),
            EdgeStruct(source: "n4", target: "n6", directed: .directed),
            EdgeStruct(source: "n6", target: "n5", directed: .directed),
            EdgeStruct(source: "n5", target: "n7", directed: .directed),
            EdgeStruct(source: "n6", target: "n8", directed: .directed),
            EdgeStruct(source: "n8", target: "n7", directed: .directed),
            EdgeStruct(source: "n8", target: "n9", directed: .directed),
            EdgeStruct(source: "n8", target: "n10", directed: .directed),
        ]
        let graph = sut.parse(xmlString: graphString)
        let expected = Graph(vertices: vertices, edges: edges, directed: .directed)
        XCTAssertEqual(graph, expected)
    }

    func testParseCustomData() {
        let sut = GraphMLFoundationParser()
        let graph = sut.parse(xmlString: GraphMLFuziParserTests.sevenCustomDataValuesXML)
        let expectedVertices: Set<Vertice> = [
            Vertice(id: "n0",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "yellow", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.997965e+38", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "5113407948167091982", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "black", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "9.11194935774537e+307", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "2548714977680485076", valueDataType: .int),
                          ]),
            Vertice(id: "n1",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "white", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.7455758e+38", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "8528121733842096482", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "magenta", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.255141819728422e+308", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "6589667584574196660", valueDataType: .int),
                          ]),
            Vertice(id: "n2",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "yellow", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.7949991e+38", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "6679833703266586095", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "magenta", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.7829445549620937e+308", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "6665473769069083584", valueDataType: .int),
                          ]),
            Vertice(id: "n3",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "white", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "3.5981702e+37", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "3598499059365498688", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "red", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "6.071940346331122e+307", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "7476512186766069714", valueDataType: .int),
                          ]),
            Vertice(id: "n4",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "blue", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.0312116e+38", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "4064142745751235316", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "red", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "5.24115302951802e+307", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "1345893486487237359", valueDataType: .int),
                          ]),
            Vertice(id: "n5",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "magenta", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "9.941552e+37", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "2345967120343992490", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "white", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "4.604726623836493e+307", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "1106465074910869863", valueDataType: .int),
                          ]),
            Vertice(id: "n6",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "black", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.4513436e+38", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "8408342339453383984", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "white", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "3.4026797728917043e+307", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "2980756907253718102", valueDataType: .int),
                          ]),
            Vertice(id: "n7",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "black", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.8509532e+38", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "657323788219753436", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "yellow", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.776938160959584e+308", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "7676117959197439107", valueDataType: .int),
                          ]),
            Vertice(id: "n8",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "magenta", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.7042581e+38", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "1981961715695300594", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "black", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.016502753354606e+308", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "4182507159363442742", valueDataType: .int),
                          ]),
            Vertice(id: "n9",
                    data: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "yellow", valueDataType: .string),
                           GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.233308e+38", valueDataType: .float),
                           GraphCustomData(key: "d2", dataName: "LongValueAll", value: "3680419734927516269", valueDataType: .long),
                           GraphCustomData(key: "d3", dataName: "StringValueNode", value: "yellow", valueDataType: .string),
                           GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                           GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "5.629460823216071e+307", valueDataType: .double),
                           GraphCustomData(key: "d6", dataName: "IntValueAll", value: "2839660790318500923", valueDataType: .int),
                          ]),
        ]
        let expectedEdges: Set<EdgeStruct> = [
            EdgeStruct(source: "n3",
                       target: "n4",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "blue", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.2964748e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "2006932616603802996", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "black", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "9.944649734293026e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "7053438554945371588", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n2",
                       target: "n8",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "red", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.6261319e+37", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "8742394916074881119", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "black", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "3.4708463796013304e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "3924227735256443201", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n1",
                       target: "n5",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "yellow", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "3.2485999e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "8546345005536402528", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "yellow", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.4723096414320015e+308", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "3048572936723073765", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n4",
                       target: "n0",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.4115649e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "5051225735962247775", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "yellow", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.2246192038094603e+308", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "729538391231257073", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n6",
                       target: "n8",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "8.580904e+37", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "1003627759888922048", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "3.490339019428969e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "2600493429596903947", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n7",
                       target: "n9",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "black", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.92992e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "6620749451274293216", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "red", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.1119482856596854e+308", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "4294706495508002246", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n7",
                       target: "n0",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "red", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.8444552e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "706252498718559939", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "magenta", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "6.095904918866495e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "222781845871156127", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n8",
                       target: "n6",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "yellow", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.727684e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "2709276381422386425", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "8.451879534813068e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "7947428289111966073", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n1",
                       target: "n6",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.6861342e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "500758222341855761", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "white", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "6.693252646214114e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "5758454096778421922", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n3",
                       target: "n3",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "red", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "8.536851e+37", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "1977008316784322315", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "6.377604066599054e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "1363475704987383770", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n8",
                       target: "n0",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.0995344e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "8371945002567967735", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "red", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.14583311640401e+308", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "8351196687924126539", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n6",
                       target: "n1",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "black", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.000636e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "2691368909360324911", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "red", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.1353317359736156e+308", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "4875580109570284769", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n9",
                       target: "n2",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.7858033e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "1066586534380397586", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "blue", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "3.013554720620916e+306", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "6535886095342131975", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n5",
                       target: "n7",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "magenta", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "2.6177533e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "449830591626145303", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "blue", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "9.582767938620592e+306", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "6200227037363577410", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n2",
                       target: "n4",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "white", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.8499728e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "3956539759529661415", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "red", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "5.605504717954664e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "3890712591912290873", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n9",
                       target: "n5",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "white", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "3.0285388e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "536864920023884671", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "white", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.4893121000949964e+308", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "3987315015660321095", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n0",
                       target: "n0",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "white", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "7.311948e+37", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "9176990211375483821", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "yellow", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.0968316966636985e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "183441927153824516", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n4",
                       target: "n2",
                       directed: .directed,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "orange", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.4643623e+38", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "2434736200612418477", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "red", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.2587426644139495e+308", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "3421918315247225518", valueDataType: .int),
                                        ]),
            EdgeStruct(source: "n5",
                       target: "n2",
                       directed: .undirected,
                       graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "magenta", valueDataType: .string),
                                         GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "7.951335e+37", valueDataType: .float),
                                         GraphCustomData(key: "d2", dataName: "LongValueAll", value: "1788129042836424563", valueDataType: .long),
                                         GraphCustomData(key: "d3", dataName: "StringValueNode", value: "yellow", valueDataType: .string),
                                         GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "false", valueDataType: .boolean),
                                         GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.9379278586209808e+307", valueDataType: .double),
                                         GraphCustomData(key: "d6", dataName: "IntValueAll", value: "4577093235816578299", valueDataType: .int),
                                        ])
        ]
        XCTAssertEqual(graph, Graph(vertices: expectedVertices,
                                    edges: expectedEdges,
                                    directed: .undirected,
                                    graphCustomData: [GraphCustomData(key: "d0", dataName: "StringValueAll", value: "magenta", valueDataType: .string),
                                                      GraphCustomData(key: "d1", dataName: "FloatValueAll", value: "1.2888971e+38", valueDataType: .float),
                                                      GraphCustomData(key: "d2", dataName: "LongValueAll", value: "9025680419018481014", valueDataType: .long),
                                                      GraphCustomData(key: "d3", dataName: "StringValueNode", value: "magenta", valueDataType: .string),
                                                      GraphCustomData(key: "d4", dataName: "BoolValueAll", value: "true", valueDataType: .boolean),
                                                      GraphCustomData(key: "d5", dataName: "DoubleValueAll", value: "1.6693714602177481e+308", valueDataType: .double),
                                                      GraphCustomData(key: "d6", dataName: "IntValueAll", value: "584042775091234898", valueDataType: .int),
                                                     ]))
    }
}
