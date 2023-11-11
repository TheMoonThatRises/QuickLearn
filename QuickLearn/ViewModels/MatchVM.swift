//
//  MatchVM.swift
//  QuickLearn
//
//  This file is part of QuickLearn.
//
//  QuickLearn is free software: you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation,
//  either version 3 of the License, or (at your option) any later version.
//
//  QuickLearn is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along with QuickLearn.
//  If not, see https://www.gnu.org/licenses/.
//

import Foundation
import SwiftUI
import AlertToast

class MatchVM: GenericLearnVM {
    @Published var terms: [UUID] = []
    @Published var definitions: [UUID] = []

    @Published var selectedTerm: UUID? {
        didSet {
            checkAnswer()
        }
    }
    @Published var selectedDefinition: UUID? {
        didSet {
            checkAnswer()
        }
    }

    var termIndex: Int? {
        self.set.setList.firstIndex { $0.id == selectedTerm }
    }

    var definitionIndex: Int? {
        self.set.setList.firstIndex { $0.id == selectedDefinition }
    }

    override var correctToast: AlertToast {
        AlertToast(displayMode: .alert, type: .complete(.green), title: "Correct!")
    }

    override var incorrectToast: AlertToast {
        AlertToast(displayMode: .alert, type: .error(.red), title: "Inorrect")
    }

    override var noStarsToast: AlertToast {
        AlertToast(displayMode: .banner(.pop), type: .error(.red), title: "No starred terms, using all items")
    }

    override func generateIndexes() {
        switch writeOrder {
        case .inOrder:
            terms = set.setList.map { $0.id }
            definitions = set.setList.shuffled().map { $0.id }
        case .random:
            terms = set.setList.map { $0.id }
            definitions = set.setList.shuffled().map { $0.id }
        case .star:
            let stars = set.setList.filter { $0.isStarred }

            if stars.isEmpty {
                writeOrder = .random
                showNoStars = true
                generateIndexes()
            } else {
                terms = stars.shuffled().map { $0.id }
                definitions = stars.shuffled().map { $0.id }
            }
        }

        originalSet = terms
    }

    private func checkAnswer() {
        if let selectedTerm = selectedTerm, let selectedDefinition = selectedDefinition,
            let termIndex = termIndex {
            set.setList[termIndex].seenCount += 1

            if selectedTerm == selectedDefinition {
                showCorrect = true

                set.setList[termIndex].successCount += 1
                set.setList[termIndex].recentFail = false

                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 1_500_000_000)

                    showCorrect = false

                    withAnimation {
                        self.selectedTerm = nil
                        self.selectedDefinition = nil

                        terms = terms.filter { $0 != selectedTerm }
                        definitions = definitions.filter { $0 != selectedDefinition }

                        if terms.isEmpty {
                            isFinished = true
                        }
                    }
                }
            } else {
                showIncorrect = true

                set.setList[termIndex].failCount += 1
                set.setList[termIndex].recentFail = true

                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 1_500_000_000)

                    showIncorrect = false
                }
            }
        }
    }
}
