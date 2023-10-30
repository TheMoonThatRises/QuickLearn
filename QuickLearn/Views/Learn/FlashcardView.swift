//
//  FlashcardView.swift
//  QuickLearn
//
//  Created by RangerEmerald on 10/29/23.
//

import SwiftUI

struct FlashcardView: View {
    var set: LearnSet

    @State var cardIndex = 0
    @State var isFlipped = false

    @State var isFinished = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if isFinished {
                    FinishView(type: .flashcards, set: set)
                } else {
                    Text("Card \(cardIndex + 1) of \(set.setList.count)")
                        .bold()
                        .font(.title2)
                        .padding()
                    Spacer()
                    
                    Button {
                        if cardIndex == set.setList.count - 1 && isFlipped {
                            withAnimation {
                                isFinished = true
                            }
                        } else {
                            increment()
                        }
                    } label: {
                        let card = set.setList[cardIndex]
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(isFlipped ? "Definition: " : "Term: ")
                                    .bold()
                                    .font(.title3)
                                Text(isFlipped ? card.definition : card.term)
                                    .font(.title)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                    .buttonStyle(.plain)
                    HStack {
                        Spacer()
                        Button {
                            decrement()
                        } label: {
                            Label("Previous", systemImage: "arrow.left")
                        }
                        .disabled(cardIndex <= 0 && !isFlipped)
                        Spacer()
                        Button {
                            increment()
                        } label: {
                            Label("Next", systemImage: "arrow.right")
                        }
                        Spacer()
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .navigationTitle("Flashcards")
        }
    }

    private func increment() {
        withAnimation {
            if cardIndex == set.setList.count - 1 && isFlipped {
                isFinished = true
            } else {
                if isFlipped {
                    cardIndex += 1
                }

                isFlipped.toggle()
            }
        }
    }

    private func decrement() {
        withAnimation {
            if !isFlipped {
                cardIndex -= 1
            }

            isFlipped.toggle()
        }
    }
}
