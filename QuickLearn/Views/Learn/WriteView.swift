//
//  WriteView.swift
//  QuickLearn
//
// This file is part of QuickLearn.
//
// QuickLearn is free software: you can redistribute it and/or modify it under the terms
// of the GNU General Public License as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// QuickLearn is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with QuickLearn.
// If not, see https://www.gnu.org/licenses/.
//

import SwiftUI
import AlertToast

struct WriteView: View {
    @StateObject var viewModel: WriteVM

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if viewModel.isFinished {
                    FinishView(type: .write, viewedCards: viewModel.originalSet)
                } else {
                    Text("Write \(viewModel.cardsIn) of \(viewModel.originalSet.count)")
                        .bold()
                        .font(.title2)
                        .padding()

                    Spacer()

                    Text(viewModel.writeType == .term ? "Definition:" : "Term:")
                        .bold()
                        .font(.title)
                        .padding()
                    Text(viewModel.writeType == .term ? viewModel.card.definition : viewModel.card.term)
                        .font(.title3)
                        .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 40))

                    Spacer()

                    Text(viewModel.writeType == .term ? "Term:" : "Definition:")
                        .bold()
                        .font(.title2)
                        .padding()
                    TextField("Answer", text: $viewModel.answer)
                        .disabled(viewModel.showCorrect || viewModel.showIncorrect)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor)
                        }
                        .padding()

                    HStack {
                        Spacer()

                        Button("Check") {
                            viewModel.checkAnswer()
                        }
                        .disabled(viewModel.showCorrect || viewModel.showIncorrect)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor)
                        }
                        .padding()
                    }

                    Spacer()
                }
            }
            .navigationTitle("Write")
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
