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
            Grid {
                GridRow {
                    Text("Term")
                    Spacer()
                    GroupBox {
                        TextField("", text: $termSet.term, axis: .vertical)
                    }
                    .padding()
                }
                Divider()
                GridRow {
                    Text("Definition")
                    Spacer()
                    GroupBox {
                        TextField("", text: $termSet.definition, axis: .vertical)
                    }
                    .padding()
                }
                Divider()
                GridRow {
                    Text("Starred")
                    Spacer()
                    Toggle("",
                           systemImage: termSet.isStarred ? "star.fill" : "star",
                           isOn: $termSet.isStarred
                    ).labelsHidden()
                }
                Divider()
                GridRow {
                    Text("Reviewed")
                    Spacer()
                    Text("\(termSet.seenCount)")
                }
                Divider()
                GridRow {
                    Text("Passed")
                    Spacer()
                    Text("\(termSet.successCount)")
                        .foregroundStyle(.green)
                }
                Divider()
                GridRow {
                    Text("Failed")
                    Spacer()
                    Text("\(termSet.failCount)")
                        .foregroundStyle(.red)
                }
                Divider()
                GridRow {
                    Text("Recently Failed")
                    Spacer()
                    Text(termSet.recentFail ? "Yes" : "No")
                        .foregroundStyle(termSet.recentFail ? .red : .green)
                }
            }
            .navigationTitle("TermSet \(termSet.id)")
            .padding()
        }
    }
}
