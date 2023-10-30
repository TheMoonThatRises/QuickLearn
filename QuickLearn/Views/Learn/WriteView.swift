//
//  WriteView.swift
//  QuickLearn
//
//  Created by RangerEmerald on 10/29/23.
//

import SwiftUI

struct WriteView: View {
    var set: LearnSet

    @State var cardIndex = 0 {
        didSet {
            answer = ""
        }
    }

    @State var writeOrder: WriteOrder = .random
    @State var writeType: WriteType = .term

    @State var answer = ""
    @State var showCorrect = false
    @State var showIncorrect = false

    @State var isFinished = false

    var body: some View {
        NavigationStack {
            let card = set.setList[cardIndex]

            VStack(alignment: .leading) {
                if isFinished {
                    FinishView(type: .write, set: set)
                } else {
                    Text("Write \(cardIndex + 1) of \(set.setList.count)")
                        .bold()
                        .font(.title2)
                        .padding()

                    Spacer()

                    Text(writeType == .term ? "Definition:" : "Term:")
                        .bold()
                        .font(.title)
                        .padding()
                    Text(writeType == .term ? card.definition : card.term)
                        .font(.title3)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))

                    Spacer()

                    Text(writeType == .term ? "Term:" : "Definition:")
                        .bold()
                        .font(.title2)
                    TextField("Answer", text: $answer)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.blue)
                        }
                        .padding()
                    Spacer()

                    Button("Check") {
                        checkAnswer(isButtonPress: true)
                    }
                }
            }
            .navigationTitle("Write")
            .disabled(showCorrect)
            .overlay {
                if showCorrect || showIncorrect {
                    VStack {
                        if showCorrect {
                            Text("Correct!")
                                .padding()
                        } else if showIncorrect {
                            Text("Incorrect. The correct answer was:")
                            Text(writeType == .term ? card.term : card.definition)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                    .padding()
                }
            }
            .onChange(of: answer) {
               checkAnswer(isButtonPress: false)
            }
        }
    }

    private func checkAnswer(isButtonPress: Bool) {
        let card = set.setList[cardIndex]

        let correctAnswer = writeType == .term ? card.term : card.definition

        if correctAnswer.lowercased().replacingOccurrences(of: " ", with: "") ==
            answer.lowercased().replacingOccurrences(of: " ", with: "") {

            withAnimation {
                showCorrect = true
            }

            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)

                withAnimation {
                    showCorrect = false
                }

                increment()
            }

            set.setList[cardIndex].successCount += 1
        } else if isButtonPress {
            set.setList[cardIndex].failCount += 1
            set.setList[cardIndex].recentFail = true

            withAnimation {
                showIncorrect = true
            }

            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)

                withAnimation {
                    showIncorrect = false
                }

                increment()
            }
        }
    }

    private func increment() {
        withAnimation {
            guard cardIndex < set.setList.count - 1 else {
                return isFinished = true
            }

            cardIndex += 1

            set.setList[cardIndex].seenCount += 1
        }
    }
}
