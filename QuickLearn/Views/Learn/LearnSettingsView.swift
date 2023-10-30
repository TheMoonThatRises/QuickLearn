//
//  LearnSettingsView.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
//

import SwiftUI

struct LearnSettingsView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var writeType: WriteType
    @Binding var writeOrder: WriteOrder

    var body: some View {
        NavigationStack {
            List {
                Picker("Learn Content", selection: $writeType) {
                    ForEach(WriteType.allCases, id: \.self) { option in
                        HStack {
                            Text(option.rawValue)
                        }
                        .tag(option)
                    }
                    .pickerStyle(.menu)
                }
                Picker("Order", selection: $writeOrder) {
                    ForEach(WriteOrder.allCases, id: \.self) { option in
                        HStack {
                            Text(option.rawValue)
                        }
                        .tag(option)
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onChange(of: writeOrder) {
                dismiss()
            }
            .onChange(of: writeType) {
                dismiss()
            }
        }
    }
}
