//
//  WordTableViewCell.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 04.10.2023.
//

import Foundation
import UIKit

class WordTableViewCell: UITableViewCell {
    static let identifier = "wordcell"
    
    func setUpContent(text: String) {
        var content = self.defaultContentConfiguration()
        content.text = text
        content.textProperties.color = .systemGray
        self.contentView.backgroundColor = .tertiarySystemGroupedBackground
        self.contentConfiguration = content
    }
}

