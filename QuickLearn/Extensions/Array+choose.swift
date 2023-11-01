//
//  Array+choose.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
//

import Foundation

struct WeightedTermSet {
    let randValue: Double
    var weight: Double
    let termSet: TermSet

    init(randValue: Double, termSet: TermSet) {
        self.randValue = randValue
        self.termSet = termSet

        self.weight = (
            Double(termSet.successCount) * Double(termSet.seenCount) * Double(termSet.recentFail ? 0.5 : 0.1)
        ) / Double(termSet.failCount + 1)
    }
}

extension Collection<TermSet> {
    func weightedShuffle() -> [TermSet] {
        let weighted: [WeightedTermSet] = self.map {
            WeightedTermSet(
                randValue: Double.random(in: 0...1),
                termSet: $0
            )
        }.sorted(by: { $0.randValue > 0.6 ? $0.weight < $1.weight : $0.randValue < $1.randValue })

        return weighted.map { $0.termSet }
    }

    func choose(_ count: Int) -> ArraySlice<Element> {
        weightedShuffle().prefix(count)
    }
}
