//
//  CodableLearnSet.swift
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

class CodableLearnSet: Codable {
    enum CodingKeys: CodingKey {
        case name
        case desc
        case setList
    }

    var name: String
    var desc: String

    var setList: [CodableTermSet]

    init(name: String, desc: String, setList: [CodableTermSet]) {
        self.name = name
        self.desc = desc

        self.setList = setList
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        try self.init(name: container.decode(String.self, forKey: .name),
                      desc: container.decode(String.self, forKey: .desc),
                      setList: container.decode([CodableTermSet].self, forKey: .setList))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(desc, forKey: .desc)
        try container.encode(setList, forKey: .setList)
    }

    public static func fromLearnSet(set: LearnSet) -> CodableLearnSet {
        CodableLearnSet(name: set.name,
                        desc: set.desc,
                        setList: set.setList.map { CodableTermSet.fromTermSet(termSet: $0) })
    }

    public static func toLearnSet(set: CodableLearnSet) -> LearnSet {
        LearnSet(name: set.name,
                 desc: set.desc,
                 setList: set.setList.map { CodableTermSet.toTermSet(termSet: $0) })
    }
}

struct CodableTermSet: Codable {
    enum CodingKeys: CodingKey {
        case term
        case definition
    }

    var term: String
    var definition: String

    init(term: String, definition: String) {
        self.term = term
        self.definition = definition
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.init(term: try container.decode(String.self, forKey: .term),
                  definition: try container.decode(String.self, forKey: .definition))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(term, forKey: .term)
        try container.encode(definition, forKey: .definition)
    }

    public static func fromTermSet(termSet: TermSet) -> CodableTermSet {
        CodableTermSet(term: termSet.term, definition: termSet.definition)
    }

    public static func toTermSet(termSet: CodableTermSet) -> TermSet {
        TermSet(term: termSet.term, definition: termSet.definition)
    }
}
