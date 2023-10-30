//
//  CreateSetView.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/28/23.
//

import SwiftUI

struct CreateSetView: View {
    @Environment(\.dismiss) var dismiss

    var addItem: (LearnSet) -> Void

    @State var setName = ""
    @State var setDescription = ""

    @State var setLists: [TermSet] = [.init(term: "", definition: "")]

    var canSubmit: Bool {
        !setName.isEmpty &&
        (
            !setDescription.isEmpty ||
            (!(setLists.first?.term.isEmpty ?? true) || !(setLists.first?.definition.isEmpty ?? true))
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("LearnSet Name (e.g. AP Biology Vocab)", text: $setName)
                    TextField("LearnSet Description (e.g. List to study for vocab test)", text: $setDescription)
                } header: {
                    Text("Info")
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
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor)
                            .fill(Color.gray.opacity(0.3))
                        Button {
                            withAnimation {
                                setLists.append(.init(term: "", definition: ""))
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
                } header: {
                    Text("LearnSet Cards")
                }
            }
            .navigationTitle("Create New LearnSet")
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
