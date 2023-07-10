//
//  ContentView.swift
//  GraphMLGenerator
//
//  Created by Bartlomiej Zdybowicz on 10/07/2023.
//

import SwiftUI

struct GeneratorInput {
    var numberOfNodesInput: String = ""
    var edgesInputMin: String = ""
    var edgesInputMax: String = ""

    var numberOfNodes: Int {
        if let int = Int(numberOfNodesInput) {
            return int
        } else {
            return Int.random(in: 10000...100000)
        }
    }

    var edgesPerNode: Int {
        guard let min = Int(edgesInputMin), let max = Int(edgesInputMax) else {
            return Int.random(in: 1..<5)
        }
        return Int.random(in: min..<max)
    }
}

struct GeneratorInputView: View {

    private let generator: GeneratorProtocol
    @State var input = GeneratorInput()

    init(generator: GeneratorProtocol = Generator()) {
        self.generator = generator
    }

    var body: some View {
        VStack {
            HStack {
                Text("Number of nodes:")
                TextField("Type integer number", text: $input.numberOfNodesInput)
            }
            //Spacer(minLength: 20)
            Text("The edges count will be (pseudo) random between min and max per node - default 1...5")
            HStack {
                Text("Min edges count")
                TextField("Type int number", text: $input.edgesInputMin)
            }
            HStack {
                Text("Max edges count")
                TextField("Type int number", text: $input.edgesInputMax)
            }
            Button("Generate") {
                self.generator.generate(input: input)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorInputView()
    }
}
