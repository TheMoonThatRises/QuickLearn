//
//  GenericLearnVM.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
//

import Foundation
import SwiftUI
import AlertToast

class GenericLearnVM: ObservableObject {
    @Bindable var set: LearnSet
    @Published var allIndexes: [Int] = []

    @Published var cardIndex = 0
    @Published var isFlipped = false

    @Published var answer = ""

    var card: TermSet {
        // swiftlint:disable:next implicit_getter
        get {
            set.setList[cardIndex]
        }
    }

    var cardsIn: Int {
        self.set.setList.count - allIndexes.count
    }

    @Published var showSettingsSheet = false

    @AppStorage("writeType") var writeType: TypeSetting = .term
    @AppStorage("writeOrder") var writeOrder: OrderSetting = .inOrder {
        didSet {
            generateIndexes()
        }
    }

    @Published var showCorrect = false
    @Published var showIncorrect = false

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

    init(set: Bindable<LearnSet>) {
        self._set = set
        generateIndexes()
    }

    func generateIndexes() {
        allIndexes = Array(0...(set.setList.count - 1))

        if writeOrder == .random {
            allIndexes.shuffle()
        }

        cardIndex = allIndexes.removeFirst()
    }

    func checkAnswer(canFail: Bool = true) {
        let card = set.setList[cardIndex]

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
