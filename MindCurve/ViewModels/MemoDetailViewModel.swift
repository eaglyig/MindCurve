//
//  MemoDetailViewModel.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 05.10.2023.
//

import Foundation


class MemoDetailViewModel {
    private let memo: Memo

    init(memo: Memo) {
        self.memo = memo
    }
    
    func getWordCount() -> Int {
        return memo.words.count
    }
    
    func getWord(at index: Int) -> String {
        //TODO: Handle Error
        if memo.words.indices.contains(index) {
            return memo.words[index].word
        } else {
            return ""
        }
    }
    
    func getArticle(for index: Int) -> WordArticle {
        memo.words[index]
    }
    
    func getMemoTitle() -> String {
        memo.title
    }
    
    func getMemoNotes() -> String? {
        memo.notes
    }
    
    func getMemoStatus() -> MemoState {
        memo.status
    }
}
