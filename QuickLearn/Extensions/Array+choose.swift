//
//  Array+choose.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
//

import Foundation

extension Collection {
    func choose(_ count: Int) -> ArraySlice<Element> {
        shuffled().prefix(count)
    }
}
