//
//  MemoTableViewCell.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 27.08.2023.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    static let identifier = "memocell"
    
    func setUpContent(text: String) {
        var content = self.defaultContentConfiguration()
        content.text = text
        self.contentConfiguration = content
        self.accessoryType = .disclosureIndicator
    }
}
