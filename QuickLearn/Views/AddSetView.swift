//
//  AddSetView.swift
//  QuickLearn
//
//  Created by RangerEmerald on 10/28/23.
//

import SwiftUI

struct AddSetView: View {
    @Environment(\.dismiss) var dismiss

    var addItem: (LearnSet) -> Void

    @State var setName = ""
    @State var setDescription = ""
    
    @State var setLists: [TermSet] = [.init(term: "", definition: "")]

    var canSubmit: Bool {
        !setName.isEmpty && !setDescription.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("LearnSet Name (e.g. AP Biology Vocab)", text: $setName)
                    TextField("LearnSet Description (e.g. List to study for vocab test)", text: $setDescription)
                } header: {
                    Text("Metadata")
                }
                Section {
                    ForEach($setLists) { set in
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
                                setLists.append(.init(term: "", definition: ""))
                            }
                        } label: {
                            VStack(alignment: .center) {
                                Image(systemName: "plus")
                                Text("Add Term")
                            }
                        }
                    }
                } header: {
                    Text("LearnSet Cards")
                }
            }
            .navigationTitle("Add New Set")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addItem(LearnSet(name: setName,
                                         desc: setDescription,
                                         setList: setLists))
                        dismiss()
                    }
                    .disabled(!canSubmit)
                }
            }
            .onChange(of: setLists) {
                withAnimation {
                    for item in setLists where
                    item.definition.isEmpty && item.term.isEmpty && item.id != setLists.last?.id {
                        setLists.removeAll(where: { $0.id == item.id })
                    }
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                setLists.remove(at: index)
            }
        }
    }
}
