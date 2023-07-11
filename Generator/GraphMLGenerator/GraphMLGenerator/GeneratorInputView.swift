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
    var edgeDefault: EdgeDefault = .undirected
    var dataType: DataType = .string
    var elementKind: ElementKind = .node
    var customDataName: String = ""

    var customDataSet: Set<CustomData> = []
    var customDataArray: [CustomData] { Array(customDataSet) }

    var numberOfNodes: Int {
        if let int = Int(numberOfNodesInput) {
            return int
        } else {
            return Int.random(in: 10000...100000)
        }
    }

    var edgesPerNode: Int {
        guard let minValue = Int(edgesInputMin), let maxValue = Int(edgesInputMax) else {
            return Int.random(in: 1..<5)
        }
        if minValue == maxValue { return max(minValue - 1, 0) }
        if minValue > maxValue { return Int.random(in: maxValue..<minValue) }
        return Int.random(in: minValue..<maxValue)
    }

    mutating func addCustomData() {
        customDataSet.insert(CustomData(dataType: dataType,
                                          elementKind: elementKind,
                                          name: customDataName))
    }
}

struct CustomData: Equatable, Hashable {
    let dataType: DataType
    let elementKind: ElementKind
    let name: String
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
            Text("The edges count will be (pseudo) random between min and max per node - default 1...5")
            HStack {
                Text("Min edges count")
                TextField("Type int number", text: $input.edgesInputMin)
            }
            HStack {
                Text("Max edges count")
                TextField("Type int number", text: $input.edgesInputMax)
            }
            HStack {
                Picker("Edge default", selection: $input.edgeDefault, content: {
                    ForEach(EdgeDefault.allCases, id: \.self) {
                        Text($0.rawValue.capitalized).tag($0)
                    }
                })
                .pickerStyle(.segmented)
            }
            Spacer(minLength: 10).frame(height: 100)
            HStack {
                Picker("Custom data type", selection: $input.dataType, content: {
                    ForEach(DataType.allCases, id: \.self) {
                        Text($0.rawValue.capitalized).tag($0)
                    }
                })
                .pickerStyle(.menu)
                Picker("Custom data for:", selection: $input.elementKind, content: {
                    ForEach(ElementKind.allCases, id: \.self) {
                        Text($0.rawValue.capitalized).tag($0)
                    }
                })
                .pickerStyle(.menu)
            }
            HStack {
                Text("Data name")
                TextField("Data name", text: $input.customDataName)
                Button("Tap to confirm adding custom data") {
                    self.input.addCustomData()
                }
            }
            Spacer(minLength: 10).frame(height: 100)
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
