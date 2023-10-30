//
//  FinishView.swift
//  QuickLearn
//
//  Created by RangerEmerald on 10/29/23.
//

import SwiftUI

struct FinishView: View {
    var type: LearnType
    var set: LearnSet

    var body: some View {
        NavigationStack {
            VStack {
                switch type {
                case .flashcards:
                    Text("You finished all \(set.setList.count) of the flashcards!")
                        .bold()
                        .font(.title)
                case .write:
                    Text("You finished all \(set.setList.count) writing terms!")
                        .bold()
                        .font(.title)
                case .multiple:
                    Text("")
                        .bold()
                        .font(.title)
                }
            }
            .navigationTitle("Congratulations!")
        }
    }
}
