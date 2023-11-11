//
//  FlashcardVM.swift
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

class FlashcardVM: GenericLearnVM {
    @Published var isFlipped = false

    var previousCards: [Int] = []

    var displayTerm: Bool {
        (writeType == .term && !isFlipped) || (writeType == .definition && isFlipped)
    }

    override func generateIndexes() {
        super.generateIndexes()
        isFlipped = false
        previousCards = []
    }

    override func increment() {
        withAnimation {
            if allIndexes.count <= 0 && isFlipped {
                isFinished = true
            } else {
                if isFlipped {
                    cardIndex = allIndexes.removeFirst()
                    set.setList[cardIndex].seenCount += 1
                    previousCards.append(cardIndex)
                }

                isFlipped.toggle()
            }
        }
    }

    func decrement() {
        withAnimation {
            if !isFlipped {
                allIndexes.insert(cardIndex, at: 0)
                cardIndex = previousCards.removeLast()
            }

            isFlipped.toggle()
        }
    }
}
