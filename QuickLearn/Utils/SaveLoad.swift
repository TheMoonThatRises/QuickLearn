//
//  SaveLoad.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
//

import Foundation

class SaveLoad {
    private static let propertyDecoder = JSONDecoder()
    private static let propertyEncoder = JSONEncoder()

    public static func load(data: String, type: LoadType,
                            termDelim: String? = nil, setDelim: String? = nil) throws -> LearnSet? {
        switch type {
        case .deliminator:
            if let termDelim = termDelim, let setDelim = setDelim {
                let sets = data.split(separator: setDelim)
                let termSets: [TermSet] = sets.map {
                    .init(term: String($0.split(separator: termDelim).first ?? ""),
                          definition: String($0.split(separator: termDelim).last ?? ""))
                }
                return LearnSet(name: "", desc: "", setList: termSets)
            } else {
                return nil
            }
        default:
            guard let data = data.data(using: .utf8) else {
                return nil
            }

            return CodableLearnSet.toLearnSet(set: try propertyDecoder.decode(CodableLearnSet.self, from: data))
        }
    }

    public static func encode(set: LearnSet) throws -> String? {
        return try String(data: propertyEncoder.encode(CodableLearnSet.fromLearnSet(set: set)), encoding: .utf8)
    }
}

enum LoadType: String, CaseIterable {
    case json = "JSON"
    case deliminator = "Deliminator"
}
