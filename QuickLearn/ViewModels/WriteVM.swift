//
//  WriteVM.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/30/23.
//

import Foundation

class WriteVM: GenericLearnVM {
    override var answer: String {
        didSet {
            checkAnswer(canFail: false)
        }
    }
}
