//
//  ImportSetView.swift
//  QuickLearn
//
//  Created by RangerEmerald on 10/30/23.
//

import SwiftUI
import AlertToast

struct ImportSetView: View {
    @Environment(\.dismiss) var dismiss

    var addItem: (LearnSet) -> Void

    @State var isNextView = false

    @State var setName = ""
    @State var setDescription = ""
    @State var setLists: [TermSet] = []

    @State var importString = ""
    @AppStorage("importType") var importType: LoadType = .json
    @State var termDeliminator = ""
    @State var setDeliminator = ""

    @State var showFailDecode = false
    @State var showSuccessDecode = false

    var body: some View {
        if isNextView {
            CreateSetView(dismiss: _dismiss,
                          addItem: addItem,
                          setName: setName,
                          setDescription: setDescription,
                          setLists: setLists)
        } else {
            NavigationStack {
                Form {
                    Section {
                        Picker(selection: $importType, label: Text("Import Type:")) {
                            ForEach(LoadType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                        Group {
                            TextField("Term/Definition Deliminator (tab)", text: $termDeliminator)
                            TextField("Set Deliminator (new line)", text: $setDeliminator)
                        }
                        .disabled(importType == .json)
                    } header: {
                        Text("Import Information")
                    }
                    Section {
                        GroupBox {
                            TextField("Import string", text: $importString, axis: .vertical)
                        }
                    } header: {
                        Text("Import Value")
                    }
                }
                .navigationTitle("Import LearnSet")
                .toast(isPresenting: $showFailDecode) {
                    AlertToast(displayMode: .alert, type: .error(.red), title: "Failed to decode import value")
                }
                .toast(isPresenting: $showSuccessDecode) {
                    AlertToast(displayMode: .alert, type: .complete(.green), title: "Successful import decode")
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Next") {
                            withAnimation {
                                do {
                                    let importSet = try SaveLoad.load(
                                        data: importString,
                                        type: importType,
                                        termDelim: termDeliminator.isEmpty ? "\t" : termDeliminator,
                                        setDelim: setDeliminator.isEmpty ? "\n" : setDeliminator
                                    )

                                    if let importSet = importSet {
                                        setName = importSet.name
                                        setDescription = importSet.desc
                                        setLists = importSet.setList.count > 0 ?
                                            importSet.setList: [.init(term: "", definition: "")]

                                        isNextView = true
                                    } else {
                                        throw "decode is nil"
                                    }
                                } catch {
                                    showFailDecode = true
                                }
                            }
                        }
                        .disabled(false)
                    }
                }
            }
        }
    }
}
