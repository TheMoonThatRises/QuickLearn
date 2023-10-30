//
//  FlashcardView.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/29/23.
//

import SwiftUI

struct FlashcardView: View {
    @StateObject var viewModel: FlashcardVM

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if viewModel.isFinished {
                    FinishView(type: .flashcards, set: viewModel.set)
                } else {
                    Text("Card \(viewModel.cardsIn) of \(viewModel.set.setList.count)")
                        .bold()
                        .font(.title2)
                        .padding()
                    Spacer()

                    Button {
                        viewModel.increment()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(viewModel.displayTerm ? "Term: " : "Definition: ")
                                    .bold()
                                    .font(.title3)
                                Text(viewModel.displayTerm ? viewModel.card.term : viewModel.card.definition)
                                    .font(.title)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                    .buttonStyle(.plain)
                    HStack {
                        Spacer()
                        Button {
                            viewModel.decrement()
                        } label: {
                            Label("Previous", systemImage: "arrow.left")
                        }
                        .disabled(viewModel.previousCards.count <= 0 && !viewModel.isFlipped)
                        Spacer()
                        Button {
                            viewModel.increment()
                        } label: {
                            Label("Next", systemImage: "arrow.right")
                        }
                        Spacer()
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .navigationTitle("Flashcards")
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
