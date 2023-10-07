//
//  Memo.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 12.08.2023.
//

import Foundation

enum MemoState: String {
    static let states: [MemoState] = [.negligible, .minor, .moderate, .significant]
    case negligible = "Negligible"
    case minor = "Minor"
    case moderate = "Moderate"
    case significant = "Significant"
}

struct Memo {
    var title: String
    var words: [WordArticle] = []
    var notes: String?
    var status: MemoState
    
    // MARK: - init
    
    init() {
        self.title = "Memo"
        self.status = .moderate
    }
    
    init(name: String) {
        self.title = name
        self.status = .moderate
    }
    
    init(name: String, status: MemoState) {
        self.title = name
        self.status = status
    }
    
    init(name: String, notes: String, status: MemoState) {
        self.init(name: name, status: status)
        self.notes = notes
    }
    
    init(name: String, status: MemoState, words: [WordArticle]) {
        self.init(name: name, status: status)
        self.words = words
    }
    
    init(name: String, notes: String, status: MemoState, words: [WordArticle]) {
        self.init(name: name, notes: notes, status: status)
        self.words = words
    }

}
