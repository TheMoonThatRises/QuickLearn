//
//  FlashcardVM.swift
//  QuickLearn
//
//  Created by RangerEmerald on 10/30/23.
//

import Foundation
import SwiftUI

class FlashcardVM: GenericLearnVM {
    var previousCards: [Int] = []

    var displayTerm: Bool {
        (writeType == .term && !isFlipped) || (writeType == .definition && isFlipped)
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
