//
//  LearnSettingsView.swift
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

struct LearnSettingsView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var writeType: TypeSetting
    @Binding var writeOrder: OrderSetting

    var body: some View {
        NavigationStack {
            List {
                Picker("Learn Content", selection: $writeType) {
                    ForEach(TypeSetting.allCases, id: \.self) { option in
                        HStack {
                            Text(option.rawValue)
                        }
                        .tag(option)
                    }
                    .pickerStyle(.menu)
                }
                Picker("Order", selection: $writeOrder) {
                    ForEach(OrderSetting.allCases, id: \.self) { option in
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
