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
                    TextField("", text: $termSet.term, axis: .vertical)
                }
                Divider()
                GridRow {
                    Text("Definition")
                    Spacer()
                    TextField("", text: $termSet.definition, axis: .vertical)
                }
                Divider()
                GridRow {
                    Text("Is starred")
                    Spacer()
                    Toggle("",
                           systemImage: termSet.isStarred ? "star.fill" : "star",
                           isOn: $termSet.isStarred
                    ).labelsHidden()
                }
                Divider()
                GridRow {
                    Text("Seen count")
                    Spacer()
                    Text("\(termSet.seenCount)")
                }
                Divider()
                GridRow {
                    Text("Success count")
                    Spacer()
                    Text("\(termSet.successCount)")
                }
                Divider()
                GridRow {
                    Text("Failed count")
                    Spacer()
                    Text("\(termSet.failCount)")
                }
                Divider()
                GridRow {
                    Text("Recently failed")
                    Spacer()
                    Text(termSet.recentFail ? "true" : "false")
                }
            }
            .navigationTitle("TermSet \(termSet.id)")
        }
    }
}
