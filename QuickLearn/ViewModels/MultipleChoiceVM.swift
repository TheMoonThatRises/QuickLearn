//
//  MultipleChoiceVM.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
//

import Foundation

class MultipleChoiceVM: GenericLearnVM {
    override var answer: String {
        didSet {
            if !answer.isEmpty {
                checkAnswer()
            }
        }
    }
    override var cardIndex: Int {
        didSet {
            generatePossible()
        }
    }
    @Published var possibleAnswers: [TermSet] = []

    func generatePossible() {
        var answers: [TermSet] = [set.setList[cardIndex]]
        answers.append(contentsOf: set.setList.filter { $0 != answers.first }.shuffled().choose(3))

        possibleAnswers = answers.shuffled()
    }
}
