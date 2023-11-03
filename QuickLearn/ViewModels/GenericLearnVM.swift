//
//  GenericLearnVM.swift
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

class GenericLearnVM: ObservableObject {
    @Bindable var set: LearnSet
    @Published var allIndexes: [Int] = []
    @Published var originalSet: [UUID] = []

    @Published var cardIndex = 0
    @Published var isFlipped = false

    @Published var answer = ""

    var originalCards: [TermSet] {
        // swiftlint:disable:next implicit_getter
        get {
            set.setList.filter { originalSet.contains($0.id) }
        }
    }

    var card: TermSet {
        // swiftlint:disable:next implicit_getter
        get {
            set.setList[cardIndex]
        }
    }

    var cardsIn: Int {
        originalSet.count - allIndexes.count
    }

    @Published var showSettingsSheet = false

    @AppStorage("writeType") var writeType: TypeSetting = .term
    @AppStorage("writeOrder") var writeOrder: OrderSetting = .random {
        didSet {
            generateIndexes()
        }
    }

    @Published var showCorrect = false
    @Published var showIncorrect = false
    @Published var showNoStars = false

    @Published var isFinished = false

    var correctToast: AlertToast {
        AlertToast(displayMode: .alert, type: .complete(.green), title: "Correct!")
    }

    var incorrectToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .error(.red),
                   title: "Incorrect",
                   subTitle: """
                    The correct \(writeType == .term ? "term" : "definition") is: \
                    \(writeType == .term ? card.term : card.definition)
                    """
        )
    }

    var noStarsToast: AlertToast {
        AlertToast(displayMode: .banner(.pop), type: .error(.red), title: "No starred terms, using random order")
    }

    init(set: Bindable<LearnSet>) {
        self._set = set
        generateIndexes()
    }

    func generateIndexes() {
        switch writeOrder {
        case .inOrder:
            allIndexes = Array(0...(set.setList.count - 1))
        case .random:
            allIndexes = set.setList.weightedShuffle().map { set.setList.firstIndex(of: $0)! }
        case .star:
            allIndexes = set.setList.filter { $0.isStarred }.weightedShuffle().map { set.setList.firstIndex(of: $0)! }

            if allIndexes.isEmpty {
                writeOrder = .random
                showNoStars = true
                generateIndexes()
            }
        }

        originalSet = allIndexes.map { set.setList[$0].id }

        cardIndex = allIndexes.removeFirst()
    }

    func checkAnswer(canFail: Bool = true) {
        let correctAnswer = writeType == .term ? card.term : card.definition

        if correctAnswer.lowercased().replacingOccurrences(of: " ", with: "") ==
            answer.lowercased().replacingOccurrences(of: " ", with: "") {

            showCorrect = true

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_500_000_000)

                showCorrect = false

                increment()
            }

            set.setList[cardIndex].successCount += 1
            set.setList[cardIndex].recentFail = false
        } else if canFail {
            set.setList[cardIndex].failCount += 1
            set.setList[cardIndex].recentFail = true

            showIncorrect = true

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 3_000_000_000)

                showIncorrect = false

                increment()
            }
        }
    }

    func increment() {
        withAnimation {
            guard allIndexes.count > 0 else {
                return isFinished = true
            }

            answer = ""

            cardIndex = allIndexes.removeFirst()

            set.setList[cardIndex].seenCount += 1
        }
    }
}
