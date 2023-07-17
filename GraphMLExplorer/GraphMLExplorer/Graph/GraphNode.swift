//
//  GraphNode.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 14/07/2023.
//

import Foundation
#if canImport(AppKit)
import AppKit
#endif

enum NestLevel: Int {
    case first
    case second
    case third
    case fourth
    case end

    var next: NestLevel {
        if self != .end {
            return NestLevel(rawValue: self.rawValue + 1) ?? .end
        } else {
            return .end
        }
    }

    var layoutType: LayoutType {
#if os(iOS) || os(watchOS) || os(tvOS)
        rawValue%2 == 0 ? .vertical : .horizontal
#elseif os(macOS)
        rawValue%2 == 0 ? .vertical : .horizontal
#else
        rawValue%2 == 0 ? .horizontal : .vertical
#endif
    }
}

final class GraphNode: Identifiable, ObservableObject {
    let id = UUID()
    let vertice: Vertice
    let neighbors: [GraphNode]
    let nestLevel: NestLevel

    init(vertice: Vertice, nestLevel: NestLevel, neighbors: [GraphNode]) {
        self.vertice = vertice
        self.neighbors = neighbors
        self.nestLevel = nestLevel
    }
}
