//
//  WriteView.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/29/23.
//

import SwiftUI
import AlertToast

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
                        .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 40))

                    Spacer()

                    Text(writeType == .term ? "Term:" : "Definition:")
                        .bold()
                        .font(.title2)
                        .padding()
                    TextField("Answer", text: $answer)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.blue)
                        }
                        .padding()
                    Spacer()

                    HStack {
                        Spacer()

                        Button("Check") {
                            checkAnswer(isButtonPress: true)
                        }
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.blue)
                        }
                        .padding()
                    }

                    Spacer()
                }
            }
            .navigationTitle("Write")
            .disabled(showCorrect)
            .toast(isPresenting: $showCorrect) {
                AlertToast(displayMode: .alert, type: .complete(.green), title: "Correct!")
            }
            .toast(isPresenting: $showIncorrect) {
                AlertToast(displayMode: .alert,
                           type: .error(.red),
                           title: "Incorrect",
                           subTitle: """
                                    The correct \(writeType == .term ? "term" : "definition") is: \
                                    \(writeType == .term ? card.term : card.definition)
                                    """
                )
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
                try? await Task.sleep(nanoseconds: 1_500_000_000)

                showCorrect = false

                increment()
            }

            set.setList[cardIndex].successCount += 1
            set.setList[cardIndex].recentFail = false
        } else if isButtonPress {
            set.setList[cardIndex].failCount += 1
            set.setList[cardIndex].recentFail = true

            showIncorrect = true

            Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)

                showIncorrect = false

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
