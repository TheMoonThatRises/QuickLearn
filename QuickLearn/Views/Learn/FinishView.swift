//
//  FinishView.swift
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

struct FinishView: View {
    var type: LearnType

    var viewedCards: [TermSet]

    var body: some View {
        NavigationStack {
            ScrollView {
                Text("You finished all \(viewedCards.count) of \(type.rawValue)!")
                    .bold()
                    .font(.title)
                switch type {
                case .write, .multiple, .match:
                    Spacer()

                    VStack(alignment: .leading) {
                        let incorrect = viewedCards.filter { $0.recentFail }
                        let correct = viewedCards.filter { !incorrect.contains($0) }

                        if incorrect.count > 0 {
                            Text("Incorrect:")

                            GroupBox {
                                HStack {
                                    Text("Term")
                                    Spacer()
                                    Text("Definition")
                                }
                                .bold()
                                .font(.title3)
                                ForEach(incorrect) { set in
                                    Divider()
                                    HStack {
                                        Text(set.term)
                                        Spacer()
                                        Text(set.definition)
                                            .padding()
                                        Image(systemName: "xmark")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                        }

                        Spacer()

                        if correct.count > 0 {
                            Text("Correct:")

                            GroupBox {
                                HStack {
                                    Text("Term")
                                    Spacer()
                                    Text("Definition")
                                }
                                .bold()
                                .font(.title3)
                                ForEach(correct) { set in
                                    Divider()
                                    HStack {
                                        Text(set.term)
                                        Spacer()
                                        Text(set.definition)
                                            .padding()
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.green)
                                    }
                                }
                            }
                        }

                        Spacer()
                    }
                    .padding()

                    Spacer()
                default:
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Congratulations!")
        }
    }
}
