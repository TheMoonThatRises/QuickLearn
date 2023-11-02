//
//  ImportSetView.swift
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

struct ImportSetView: View {
    @Environment(\.dismiss) var dismiss

    var addItem: (LearnSet) -> Void

    @State var isNextView = false

    @State var setName = ""
    @State var setDescription = ""
    @State var setLists: [TermSet] = []

    @State var importString = ""
    @AppStorage("importType") var importType: LoadType = .deliminator
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
                                .submitLabel(.done)
                            TextField("Set Deliminator (new line)", text: $setDeliminator)
                                .submitLabel(.done)
                        }
                        .disabled(importType == .json)
                    } header: {
                        Text("Import Information")
                    }
                    Section {
                        TextField("Import string", text: $importString, axis: .vertical)
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
                                    print(error)
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
