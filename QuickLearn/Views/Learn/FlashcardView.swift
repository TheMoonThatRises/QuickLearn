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
            GeometryReader { viewGeom in
                VStack(alignment: .leading) {
                    if viewModel.isFinished {
                        FinishView(type: .flashcards, viewedCards: viewModel.originalSet)
                    } else {
                        Text("Card \(viewModel.cardsIn) of \(viewModel.originalSet.count)")
                            .bold()
                            .font(.title2)
                            .padding()
                        Spacer()

                        HStack {
                            Spacer()
                            Button {
                                viewModel.increment()
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(viewModel.displayTerm ? "Term: " : "Definition: ")
                                        .bold()
                                        .font(.title3)
                                    Text(viewModel.displayTerm ? viewModel.card.term : viewModel.card.definition)
                                        .font(.title)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Spacer()
                                        .frame(height: 20)
                                }
                                .padding()
                                .frame(maxWidth: viewGeom.size.width * 3 / 4)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                                .padding()
                            }
                            .buttonStyle(.plain)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button {
                                viewModel.decrement()
                            } label: {
                                Label("Previous", systemImage: "arrow.left")
                            }
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                            .disabled(viewModel.previousCards.count <= 0 && !viewModel.isFlipped)
                            Spacer()
                            Button {
                                viewModel.increment()
                            } label: {
                                Label("Next", systemImage: "arrow.right")
                            }
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                            Spacer()
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Flashcards")
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
