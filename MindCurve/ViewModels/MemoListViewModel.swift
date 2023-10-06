//
//  MemoListViewModel.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 31.08.2023.
//

import Foundation


class MemoListViewModel {
    
    @Published var memos: [Memo] = []
    
    init() {
        memos = [
            Memo(
                name: "Words from 'Green mile' 5th chapter",
                notes: "What I read & what I liked",
                status: .moderate,
                words: [
                    WordArticle(word: "torrent"),
                    WordArticle(word: "noxious")
                ]
            ),
            Memo(name: "List of words from Cormen's book",
                 status: .minor,
                 words: [
                    WordArticle(word: "algorithm"),
                    WordArticle(word: "recursive"),
                 ]
            ),
            Memo(name: "Just found in web"),
            Memo(name: "Words from J. Cash's songs"),
        ]
    }
    
    func memosCount() -> Int {
        return memos.count
    }
    
    func getMemo(at index: Int) -> Memo {
        return memos[index]
        // TODO: Handle Error
    }
    
    func getMemoName(at index: Int) -> String {
        if (memos.indices.contains(index)) {
            return memos[index].title 
        } else {
            //TODO: Handle Error
            return ""
        }
    }
    
    func addMemo(memo: Memo) {
        memos.append(memo)
    }
}
