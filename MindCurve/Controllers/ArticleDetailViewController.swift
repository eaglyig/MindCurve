//
//  ArticleDetailViewController.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 06.10.2023.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    private let vm: ArticleDetailViewModel
    
    private let titleLabel = UILabel()
    private let levelLabel = UILabel()
    
    private let articleStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - init
    
    init(word: WordArticle) {
        self.vm = ArticleDetailViewModel(word: word)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up view
    
    func setUpView() {
        view.backgroundColor = .systemBackground
        titleLabel.text = vm.getTitle().capitalized
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        levelLabel.textColor = .systemRed
        levelLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        if let frequency = vm.getFrequency() {
            levelLabel.text = vm.calculateWordDifficulty(by: frequency)
            view.addSubview(levelLabel)
            levelLabel.translatesAutoresizingMaskIntoConstraints = false
            levelLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
            levelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        }
        
        articleStack.distribution = .fill
        articleStack.axis = .vertical
        vm.getAllDefinitions().forEach { definition in
            prepareArticleForStack(for: definition)
        }
        articleStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(articleStack)
        
        NSLayoutConstraint.activate([
            articleStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            articleStack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            articleStack.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            articleStack.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func prepareArticleForStack(for definition: String) {
        let textView = UITextView()
        textView.text = "\(articleStack.subviews.count + 1)) \(definition)"
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        textView.isEditable = false
        articleStack.addArrangedSubview(textView)
        
        textView.topAnchor.constraint(equalTo: articleStack.topAnchor, constant: CGFloat(articleStack.subviews.count * 50 - 20)).isActive = true
        textView.leadingAnchor.constraint(equalTo: articleStack.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: articleStack.trailingAnchor).isActive = true
        textView.heightAnchor.constraint(lessThanOrEqualToConstant: 60).isActive = true
        adjustTextViewHeight(textView: textView)
    }
    
    func adjustTextViewHeight(textView: UITextView) {
        let contentSize = textView.sizeThatFits(textView.bounds.size)

        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = contentSize.height
            }
        }
    }
}
