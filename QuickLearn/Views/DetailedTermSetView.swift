//
//  DetailedTermSetView.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
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
