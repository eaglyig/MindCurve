//
//  WordDetailViewModel.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 06.10.2023.
//

import Foundation


class ArticleDetailViewModel {
    private let article: WordArticle
    
    init(word: WordArticle) {
        self.article = word
    }
    
    func getTitle() -> String {
        article.word
    }
    
    func getFrequency() -> Double? {
        article.frequency
    }
    
    func calculateWordDifficulty(by frequency: Double) -> String {
        if frequency > 5.5 {
            return "A1"
        } else if frequency > 5 {
            return "A2"
        } else if frequency > 4 {
            return "B1"
        } else if frequency > 3 {
            return "B2"
        } else {
            return "B1"
        }
    }
    
    func getDefinitionsCount() -> Int {
        return article.results?.count ?? 0
    }
    
    func getAllDefinitions() -> [String] {
        var definitions: [String] = []
        for i in 0..<(article.results?.count ?? 0) {
            if let definition = article.results?[i].definition {
                definitions.append(definition)
            }
        }
        return definitions
    }
}
