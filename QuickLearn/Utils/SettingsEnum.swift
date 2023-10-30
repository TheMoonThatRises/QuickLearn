//
//  WriteSettings.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/29/23.
//

import Foundation

enum OrderSetting: String, CaseIterable, Equatable {
    case inOrder = "In Order"
    case random = "Random"
    case star = "Starred"
}

enum TypeSetting: String, CaseIterable, Equatable {
    case term = "Term"
    case definition = "Definition"
}
