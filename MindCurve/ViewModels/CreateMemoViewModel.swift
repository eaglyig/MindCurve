//
//  CreateMemoViewModel.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 29.09.2023.
//

import Foundation

protocol WordArticleFetchDelegate: AnyObject {
    func dataDidUpdate(data: WordArticle)
}

final class CreateMemoViewModel {
    
    weak var delegate: WordArticleFetchDelegate?
    private var memo: Memo
    
    init() {
        memo = Memo()
    }
    
    func pushWord(word: String) {
        DispatchQueue.main.async {
            //TODO: Handle Error
            if word == "" { return }
            let request = ClientRequest(pathComponent: [word]).urlRequest
            ClientService.shared.fetch(request: request) { result in
                switch result {
                case .success(let article): 
                    self.memo.words.append(article)
                    self.delegate?.dataDidUpdate(data: article)
                default: break
                }
            }
        }
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
    
    func getMemo() -> Memo {
        // TODO: Handle Error
        return memo
    }
    
    func getMemoStates() -> [String] {
        MemoState.states.map { $0.rawValue }
    }
    
    func setMemoState(memoPosition: Int) {
        switch memoPosition {
        case 0: memo.status = .negligible
        case 1: memo.status = .minor
        case 2: memo.status = .moderate
        case 3: memo.status = .significant
        default: memo.status = .moderate
        }
    }
    
    func setTitle(title: String) {
        if !title.isEmpty {
            self.memo.title = title
        }
    }
    
    func setNotes(notes: String) {
        if !notes.isEmpty {
            self.memo.notes = notes
        }
    }
}
