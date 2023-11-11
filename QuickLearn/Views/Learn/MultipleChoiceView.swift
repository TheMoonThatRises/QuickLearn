//
//  MultipleChoiceView.swift
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

import SwiftUI
import AlertToast

struct MultipleChoiceView: View {
    @StateObject var viewModel: MultipleChoiceVM

    var body: some View {
        NavigationStack {
            GeometryReader { geom in
                VStack(alignment: .leading) {
                    if viewModel.isFinished {
                        FinishView(type: .multiple, viewedCards: viewModel.originalCards, reset: viewModel.reset)
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
                            let columns = Array(repeating: GridItem(.flexible()), count: geom.size.width > 800 ? 2 : 1)
                            LazyVGrid(columns: columns) {
                                ForEach(viewModel.possibleAnswers) { answer in
                                    let answerAnswer = viewModel.writeType == .term ? answer.term : answer.definition
                                    Button {
                                        viewModel.answer = answerAnswer
                                    } label: {
                                        Text(answerAnswer)
                                            .font(.title2)
                                            .frame(maxWidth: .infinity)
                                            .padding()
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
