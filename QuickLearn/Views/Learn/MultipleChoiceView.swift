//
//  MultipleChoiceView.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
//

import SwiftUI
import AlertToast

struct MultipleChoiceView: View {
    @StateObject var viewModel: MultipleChoiceVM

    var body: some View {
        NavigationStack {
            GeometryReader { geom in
                VStack(alignment: .leading) {
                    if viewModel.isFinished {
                        FinishView(type: .multiple, viewedCards: viewModel.originalSet)
                    } else {
                        Text("Write \(viewModel.cardsIn) of \(viewModel.originalSet.count)")
                            .bold()
                            .font(.title2)
                            .padding()

                        Spacer()

                        Text(viewModel.writeType == .term ? "Definition:" : "Term:")
                            .bold()
                            .font(.title3)
                            .padding()
                        Text(viewModel.writeType == .term ? viewModel.card.definition : viewModel.card.term)
                            .font(.title)
                            .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 40))

                        Spacer()

                        Text(viewModel.writeType == .term ? "Term:" : "Definition:")
                            .bold()
                            .font(.title3)
                            .padding()

                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.possibleAnswers) { answer in
                                    let answerAnswer = viewModel.writeType == .term ? answer.term : answer.definition
                                    Button {
                                        viewModel.answer = answerAnswer
                                    } label: {
                                        Text(answerAnswer)
                                            .font(.title2)
                                            .padding()
                                            .frame(width: geom.size.width / 5 * 2)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.accentColor)
                                            }
                                            .padding()
                                    }
                                }
                            }
                        }
                        .disabled(viewModel.showCorrect || viewModel.showIncorrect)

                        Spacer()
                    }
                }
            }
            .navigationTitle("Multiple Choice")
            .disabled(viewModel.showCorrect)
            .toast(isPresenting: $viewModel.showCorrect, tapToDismiss: false) {
                viewModel.correctToast
            }
            .toast(isPresenting: $viewModel.showIncorrect, tapToDismiss: false) {
                viewModel.incorrectToast
            }
            .toast(isPresenting: $viewModel.showNoStars) {
                viewModel.noStarsToast
            }
            .sheet(isPresented: $viewModel.showSettingsSheet) {
                LearnSettingsView(writeType: $viewModel.writeType, writeOrder: $viewModel.writeOrder)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        viewModel.showSettingsSheet = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}
