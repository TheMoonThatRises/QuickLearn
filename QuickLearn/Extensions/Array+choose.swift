//
//  Array+choose.swift
//  QuickLearn
//
// This file is part of QuickLearn.
//
// QuickLearn is free software: you can redistribute it and/or modify it under the terms
// of the GNU General Public License as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// QuickLearn is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with QuickLearn.
// If not, see https://www.gnu.org/licenses/.
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
