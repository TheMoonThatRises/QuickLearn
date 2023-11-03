//
//  DetailedTermSetView.swift
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

struct DetailedTermSetView: View {
    @Binding var termSet: TermSet

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Term:")
                        Spacer()
                            .frame(width: 10)
                        TextField("", text: $termSet.term, axis: .vertical)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack {
                        Text("Definition:")
                        Spacer()
                            .frame(width: 10)
                        TextField("", text: $termSet.definition, axis: .vertical)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack {
                        Text("Starred:")
                        Spacer()
                        Button {
                            termSet.isStarred.toggle()
                        } label: {
                            HStack {
                                Text(termSet.isStarred ? "Yes" : "No")
                                Image(systemName: termSet.isStarred ? "star.fill" : "star")
                                    .foregroundStyle(.yellow)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Information")
                }
                Section {
                    HStack {
                        Text("Reviewed:")
                        Spacer()
                        Text("\(termSet.seenCount)")
                    }
                    HStack {
                        Text("Passed:")
                        Spacer()
                        Text("\(termSet.successCount)")
                            .foregroundStyle(.green)
                    }
                    HStack {
                        Text("Failed:")
                        Spacer()
                        Text("\(termSet.failCount)")
                            .foregroundStyle(.red)
                    }
                    HStack {
                        Text("Recently Failed:")
                        Spacer()
                        Text(termSet.recentFail ? "Yes" : "No")
                            .foregroundStyle(termSet.recentFail ? .red : .green)
                    }
                } header: {
                    Text("Stats")
                }
            }
            .navigationTitle("TermSet \(termSet.id)")
            .padding()
        }
    }
}
