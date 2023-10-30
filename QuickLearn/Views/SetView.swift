//
//  SetView.swift
//  QuickLearn
//
//  Created by RangerEmerald on 10/29/23.
//

import SwiftUI

struct SetView: View {
    @Bindable var set: LearnSet

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $set.desc)
                        .font(.title3)
                } header: {
                    Text("Description")
                }
                Section {
                    Text("LearnSet Cards Count: \(set.setList.count)")
                        .font(.subheadline)
                } header: {
                    Text("Metadata")
                }

                Section {
                    NavigationLink {
                        FlashcardView(set: set)
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.fill.on.rectangle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Flashcards")
                        }
                    }
                    NavigationLink {
                        WriteView(set: set)
                    } label: {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Write")
                        }
                    }
                    NavigationLink {

                    } label: {
                        HStack {
                            Image(systemName: "list.clipboard.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Multiple Choice")
                        }
                    }
                } header: {
                    Text("Learning Options")
                }

                Section {
                    Picker("Sort Options", selection: $set.sortMethod) {
                        HStack {
                            Text(set.sortMethod.value)
                            Image(systemName: set.sortMethod.isAscending ? "arrow.up" : "arrow.down")
                        }
                        .tag(set.sortMethod)

                        ForEach(sortFields.filter { $0 != set.sortMethod }, id: \.self) { option in
                            HStack {
                                Text(option.value)
                                if set.sortMethod.value == option.value {
                                    Image(systemName: option.isAscending ? "arrow.up" : "arrow.down")
                                }
                            }
                            .tag(option)
                        }
                        .pickerStyle(.menu)
                    }

                    List {
                        ForEach($set.setList) { set in
                            GroupBox {
                                TextField(text: set.term) {
                                    Text("Term (e.g. Mitochondria)")
                                }
                                Divider()
                                TextField(text: set.definition) {
                                    Text("Definition (e.g. The powerhouse of the cell)")
                                }
                            }
                            .autocorrectionDisabled()
                        }
                        .onDelete(perform: deleteItems)
                        GroupBox {
                            TextField("Term", text: .constant(""))
                            Divider()
                            TextField("Definition", text: .constant(""))
                        }
                        .disabled(true)
                        .overlay {
                            Button {
                                withAnimation {
                                    set.setList.append(.init(term: "", definition: ""))
                                }
                            } label: {
                                VStack(alignment: .center) {
                                    Image(systemName: "plus")
                                    Text("Add Term")
                                }
                            }
                        }
                    }
                } header: {
                    Text("LearnSet Cards")
                }
            }
            .navigationTitle($set.name)
            .padding()
            .onChange(of: set.setList) {
                for item in set.setList where
                    item.definition.isEmpty && item.term.isEmpty && item.id != set.setList.last?.id {
                        set.setList.removeAll(where: { $0.id == item.id })
                }
            }
            .onChange(of: set.sortMethod) {
                withAnimation {
                    switch set.sortMethod {
                    case .alpha( _):
                        set.setList.sort { $0.term > $1.term }
                    case .star(_):
                        set.setList.sort { $0.isStarred && !$1.isStarred }
                    case .fail(_):
                        set.setList.sort {
                            ($0.seenCount == 0 || $1.seenCount == 0) ||
                            ($0.failCount / $0.seenCount < $1.failCount / $1.seenCount)
                        }
                    }

                    if !set.sortMethod.isAscending {
                        set.setList.reverse()
                    }
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                set.setList.remove(at: index)
            }
        }
    }

    var sortFields: [SortMethod] {
        var sortFields: [SortMethod] = []

        sortFields.append(.alpha(asc: .alpha(asc: false) == set.sortMethod))
        sortFields.append(.star(asc: .star(asc: false) == set.sortMethod))
        sortFields.append(.fail(asc: .fail(asc: false) == set.sortMethod))

        return sortFields
    }
}
