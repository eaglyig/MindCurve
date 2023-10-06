//
//  Word.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 31.08.2023.
//

import Foundation

struct WordArticle: Decodable {
    let word: String
    let results: [WordResult]?
    let syllables: WordSyllables?
    let pronunciation: [String:String]?
    let frequency: Double?
    
    struct WordResult: Decodable {
        let definition: String?
        let partOfSpeech: String?
        let synonyms: [String]?
        let typeOf: [String]?
        let hasTypes: [String]?
        let derivation: [String]?
    }
    
    struct WordSyllables: Decodable {
        let count: Int
        let list: [String]
    }

    init(word: String) {
        self.word = word
        results = nil
        syllables = nil
        pronunciation = nil
        frequency = nil
    }

}
