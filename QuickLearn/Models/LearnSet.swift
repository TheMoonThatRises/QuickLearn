//
//  LearnSet.swift
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

import Foundation
import SwiftData

@Model
class LearnSet {
    @Attribute(.unique) var id: UUID

    var name: String
    var desc: String

    var sortMethod: SortMethod

    var setList: [TermSet]

    init(name: String, desc: String, setList: [TermSet]) {
        self.id = UUID()

        self.name = name
        self.desc = desc

        self.sortMethod = .alpha(asc: true)

        self.setList = setList
    }
}

struct TermSet: Codable, Identifiable, Equatable {
    var id: UUID

    var term: String
    var definition: String

    var isStarred: Bool

    var seenCount: Int
    var successCount: Int
    var failCount: Int

    var recentFail: Bool

    init(term: String, definition: String) {
        self.id = UUID()
        self.term = term
        self.definition = definition

        self.isStarred = false

        self.seenCount = 0
        self.successCount = 0
        self.failCount = 0

        self.recentFail = false
    }
}

enum SortMethod: Codable, Hashable {
    case alpha(asc: Bool), star(asc: Bool), fail(asc: Bool)

    var value: String {
        switch self {
        case .alpha: "Alphabetic"
        case .star: "Starred"
        case .fail: "Fail Percent"
        }
    }

    var isAscending: Bool {
        switch self {
        case .alpha(let asc), .star(let asc), .fail(let asc):
            return asc
        }
    }

    var inverse: Self {
        switch self {
        case .alpha(let asc):
            return .alpha(asc: !asc)
        case .star(let asc):
            return .star(asc: !asc)
        case .fail(let asc):
            return .fail(asc: !asc)
        }
    }
}
