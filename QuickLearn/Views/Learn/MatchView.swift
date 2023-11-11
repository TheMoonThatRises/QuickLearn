//
//  MatchView.swift
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

struct MatchView: View {
    @StateObject var viewModel: MatchVM

    var body: some View {
        NavigationStack {
            GeometryReader { geom in
                if viewModel.isFinished {
                    FinishView(type: .match, viewedCards: viewModel.originalCards, reset: viewModel.reset)
                } else {
                    if geom.size.width < 800 {
                        MinimizedMatchView()
                            .environmentObject(viewModel)
                    } else {
                        FullMatchView()
                            .environmentObject(viewModel)
                    }
                }
            }
            .navigationTitle("Match")
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

struct MinimizedMatchView: View {
    @EnvironmentObject var matchVM: MatchVM

    var body: some View {
        ScrollView {
            Text("Terms")
                .font(.largeTitle)

            Divider()
            Spacer()

            ForEach(matchVM.terms, id: \.self) { termID in
                Button {
                    matchVM.selectedTerm = matchVM.selectedTerm == termID ? nil : termID
                } label: {
                    let isSelected = matchVM.selectedTerm == termID
                    let term = matchVM.set.setList.filter { $0.id == termID }.first?.term
                    Text((term?.isEmpty == true ? "No Term" : term) ?? "Unknown")
                        .font(.title)
                        .background(isSelected ? Color.accentColor : Color(UIColor.systemBackground))
                        .foregroundColor(isSelected ? Color(UIColor.systemBackground) : Color.accentColor)
                        .padding()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 1)
                )

                Spacer()
            }

            Divider()
            Spacer()

            Text("Definitions")
                .font(.largeTitle)

            Divider()
            Spacer()

            ForEach(matchVM.definitions, id: \.self) { definitionID in
                Button {
                    matchVM.selectedDefinition = matchVM.selectedDefinition == definitionID ? nil : definitionID
                } label: {
                    let isSelected = matchVM.selectedDefinition == definitionID
                    let definition = matchVM.set.setList.filter { $0.id == definitionID }.first?.definition
                    Text((definition?.isEmpty == true ? "No Definition" : definition) ?? "Unknown")
                        .font(.title)
                        .background(isSelected ? Color.accentColor : Color(UIColor.systemBackground))
                        .foregroundColor(isSelected ? Color(UIColor.systemBackground) : Color.accentColor)
                        .padding()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 1)
                )

                Spacer()
            }
        }
    }
}

struct FullMatchView: View {
    @EnvironmentObject var matchVM: MatchVM

    var body: some View {
        HStack {
            ScrollView {
                Text("Terms")
                    .font(.largeTitle)

                Divider()
                Spacer()

                ForEach(matchVM.terms, id: \.self) { termID in
                    Button {
                        matchVM.selectedTerm = matchVM.selectedTerm == termID ? nil : termID
                    } label: {
                        let isSelected = matchVM.selectedTerm == termID
                        let term = matchVM.set.setList.filter { $0.id == termID }.first?.term
                        Text((term?.isEmpty == true ? "No Term" : term) ?? "Unknown")
                            .font(.title)
                            .background(isSelected ? Color.accentColor : Color(UIColor.systemBackground))
                            .foregroundColor(isSelected ? Color(UIColor.systemBackground) : Color.accentColor)
                            .padding()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )

                    Spacer()
                }
            }
            ScrollView {
                Text("Definitions")
                    .font(.largeTitle)

                Divider()
                Spacer()

                ForEach(matchVM.definitions, id: \.self) { definitionID in
                    Button {
                        matchVM.selectedDefinition = matchVM.selectedDefinition == definitionID ? nil : definitionID
                    } label: {
                        let isSelected = matchVM.selectedDefinition == definitionID
                        let definition = matchVM.set.setList.filter { $0.id == definitionID }.first?.definition
                        Text((definition?.isEmpty == true ? "No Definition" : definition) ?? "Unknown")
                            .font(.title)
                            .background(isSelected ? Color.accentColor : Color(UIColor.systemBackground))
                            .foregroundColor(isSelected ? Color(UIColor.systemBackground) : Color.accentColor)
                            .padding()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )

                    Spacer()
                }
            }
        }
    }
}
