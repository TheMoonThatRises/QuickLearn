//
//  HomeView.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/28/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var learnSets: [LearnSet]

    @State var showAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(learnSets) { item in
                    NavigationLink {
                        SetView(set: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .bold()
                                .font(.title)
                            Text(item.desc)
                                .font(.caption)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            Spacer()
                            Text("LearnSet Cards Count: \(item.setList.count)")
                                .font(.callout)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        showAddSheet = true
                    } label: {
                        Label("Create new set", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddSetView(addItem: addItem)
            }
        }
    }

    private func addItem(item: LearnSet) {
        withAnimation {
            modelContext.insert(item)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(learnSets[index])
            }
        }
    }
}
