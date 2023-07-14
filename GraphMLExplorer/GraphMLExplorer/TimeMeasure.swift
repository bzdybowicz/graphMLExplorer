//
//  TimeMeasure.swift
//  GraphMLExplorer
//
//  Created by Bartlomiej Zdybowicz on 14/07/2023.
//

import Foundation

enum TimeEvent {
    case pickFile
    case fileLoaded
    case parsingStart
    case parsingEnd
}

final class TimeMeasure {

    static let instance = TimeMeasure()

    private var table: [TimeEvent: CFTimeInterval] = [:]

    func event(_ event: TimeEvent) {
        let interval = CFAbsoluteTimeGetCurrent()
        table[event] = interval
        printResults()
    }

    func printResults() {
        if let start = table[.pickFile], let end = table[.fileLoaded] {
            print("Time from pick file to loaded \(end - start)")
        }
        if let start = table[.parsingStart], let end = table[.parsingEnd] {
            print("Time from parsing start to end \(end - start)")
        }
    }
}
