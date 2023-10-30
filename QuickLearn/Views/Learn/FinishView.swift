//
//  FinishView.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/29/23.
//

import SwiftUI

struct FinishView: View {
    var type: LearnType
    var set: LearnSet

    var body: some View {
        NavigationStack {
            ScrollView {
                switch type {
                case .flashcards:
                    Text("You finished all \(set.setList.count) of the flashcards!")
                        .bold()
                        .font(.title)
                case .write, .multiple:
                    let dtype = type == .write ? "writing" : "multiple choice"

                    Text("You finished all \(set.setList.count) \(dtype) terms!")
                        .bold()
                        .font(.title)

                    Spacer()

                    VStack(alignment: .leading) {
                        let incorrect = set.setList.filter { $0.recentFail }
                        let correct = set.setList.filter { !incorrect.contains($0) }

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
                }
            }
            .navigationTitle("Congratulations!")
        }
    }
}
