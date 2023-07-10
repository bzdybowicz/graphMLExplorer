//
//  ContentView.swift
//  GraphMLGenerator
//
//  Created by Bartlomiej Zdybowicz on 10/07/2023.
//

import SwiftUI

struct ContentView: View {

    private let generator: GeneratorProtocol

    init(generator: GeneratorProtocol = Generator()) {
        self.generator = generator
    }

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Spacer(minLength: 20)
            Button("Generate") {
                self.generator.generate()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
