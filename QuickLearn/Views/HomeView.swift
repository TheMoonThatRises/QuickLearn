//
//  HomeView.swift
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
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var learnSets: [LearnSet]

    @State var confirmCreateSet = false
    @State var showCreateSheet = false
    @State var showImportSheet = false

    @State var deleteItem: LearnSet? {
        didSet {
            if deleteItem != nil {
                confirmDelete = true
            }
        }
    }
    @State var confirmDelete = false

    @State var showSetView = false

    var body: some View {
        NavigationStack {
            List {
                if learnSets.count > 0 {
                    ForEach(learnSets) { item in
                        NavigationLink {
                            LearnSetView(set: item, delete: deleteItem)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.name.isEmpty ? "(No Name)" : item.name)
                                    .bold()
                                    .font(.title)
                                Text(item.desc.isEmpty ? "(No Desc)" : item.desc)
                                    .font(.caption)
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                Spacer()
                                Text("LearnSet Cards Count: \(item.setList.count)")
                                    .font(.callout)
                            }
                            .padding()
                        }
                    }
                    .onDelete(perform: deleteItems)
                } else {
                    Button {
                        confirmCreateSet = true
                    } label: {
                        VStack {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.accentColor)
                            Spacer()
                            Text("Create New LearnSet")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Home")
            .confirmationDialog("Are you sure you want to delete this LearnSet?",
                                isPresented: $confirmDelete,
                                presenting: deleteItem) { item in
                Button("Delete LearnSet \(item.name)", role: .destructive) {
                    withAnimation {
                        modelContext.delete(item)
                    }
                }
                Button("Cancel", role: .cancel) {
                    deleteItem = nil
                }
            }
            .confirmationDialog("Create LearnSet", isPresented: $confirmCreateSet) {
                Button("Create New LearnSet") {
                    showCreateSheet = true
                }
                Button("Import LearnSet") {
                    showImportSheet = true
                }
                Button("Cancel", role: .cancel) {
                    confirmCreateSet = false
                }
            }
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        confirmCreateSet = true
                    } label: {
                        Label("Create new set", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                CreateSetView(addItem: addItem)
            }
            .sheet(isPresented: $showImportSheet) {
                ImportSetView(addItem: addItem)
            }
        }
    }

    private func addItem(item: LearnSet) {
        withAnimation {
            modelContext.insert(item)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            deleteItem = learnSets[index]
        }
    }

    private func deleteItem(set: LearnSet) {
        deleteItem = set
    }
}
