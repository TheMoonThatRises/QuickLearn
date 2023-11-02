//
//  LearnSetView.swift
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
import AlertToast

struct LearnSetView: View {
    @Environment(\.presentationMode) var presentationMode

    @Bindable var set: LearnSet

    var delete: (LearnSet) -> Void

    @State var showExportSuccess = false
    @State var showExportError = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $set.desc)
                        .font(.title3)
                        .submitLabel(.done)
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
                        FlashcardView(viewModel: FlashcardVM(set: $set))
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.fill.on.rectangle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Flashcards")
                        }
                    }
                    NavigationLink {
                        WriteView(viewModel: WriteVM(set: $set))
                    } label: {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Write")
                        }
                    }
                    NavigationLink {
                        MultipleChoiceView(viewModel: MultipleChoiceVM(set: $set))
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
                            NavigationLink {
                                DetailedTermSetView(termSet: set)
                            } label: {
                                GroupBox {
                                    TextField("Term (e.g. Mitochondria)", text: set.term, axis: .vertical)
                                    Divider()
                                    TextField("Definition (e.g. The powerhouse of the cell)",
                                              text: set.definition,
                                              axis: .vertical)
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
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor)
                                .fill(Color.gray.opacity(0.3))
                            Button {
                                withAnimation {
                                    set.setList.append(.init(term: "", definition: ""))
                                }
                            } label: {
                                VStack(alignment: .center) {
                                    Spacer()
                                    Image(systemName: "plus")
                                    Spacer()
                                    Text("Add Term")
                                    Spacer()
                                }
                            }
                        }
                    }
                } header: {
                    Text("LearnSet Cards")
                }
            }
            .navigationTitle($set.name)
            .toast(isPresenting: $showExportSuccess) {
                AlertToast(displayMode: .alert, type: .complete(.green), title: "Copied to clipboard")
            }
            .toast(isPresenting: $showExportError) {
                AlertToast(displayMode: .alert, type: .error(.red), title: "Failed to export")
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button {
                            delete(set)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            do {
                                if let save = try SaveLoad.encode(set: set) {
                                    UIPasteboard.general.string = save
                                } else {
                                    throw "nil save string"
                                }

                                showExportSuccess = true
                            } catch {
                                print(error)
                                showExportError = true
                            }
                        } label: {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .onChange(of: set.setList) {
                for item in set.setList where
                    item.definition.isEmpty && item.term.isEmpty && item.id != set.setList.last?.id {
                        set.setList.removeAll(where: { $0.id == item.id })
                }
            }
            .onChange(of: set.sortMethod) {
                withAnimation {
                    switch set.sortMethod {
                    case .alpha:
                        set.setList.sort { $0.term > $1.term }
                    case .star:
                        set.setList.sort { $0.isStarred && !$1.isStarred }
                    case .fail:
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
