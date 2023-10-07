//
//  WordDetailCollectionCell.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 06.10.2023.
//

import UIKit

class WordDetailCollectionCell: UICollectionViewCell {
    
    static let identifier = "wordcollectioncell"
    
    private var titleLabel = UILabel()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up UI-elements
    
    func setUpUI() {
        backgroundColor = .systemGray6
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        layer.cornerRadius = 10
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setUpAppearance(title: String) {
        titleLabel.text = title
        titleLabel.textColor = .systemMint
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
}
