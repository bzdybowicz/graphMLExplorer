//
//  EdgeDefault.swift
//  GraphMLGenerator
//
//  Created by Bartlomiej Zdybowicz on 11/07/2023.
//

import Foundation

enum EdgeDefault: String, CaseIterable {
    case directed
    case undirected
    case mixed

    var xmlValue: String {
        switch self {
        case .directed: return rawValue
        case .undirected: return rawValue
        case .mixed: return "undirected"
        }
    }
}
