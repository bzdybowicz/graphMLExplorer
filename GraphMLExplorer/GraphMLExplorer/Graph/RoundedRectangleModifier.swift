//
//  RoundedRectangleModifier.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 14/07/2023.
//

import Foundation
import SwiftUI

struct RoundedRectangleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
    }
}

extension View {
    func roundedRectangle() -> some View {
        modifier(RoundedRectangleModifier())
    }
}
