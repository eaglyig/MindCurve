//
//  MemoDetailViewController.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 28.08.2023.
//

import UIKit

class MemoDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var vm: MemoDetailViewModel
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let notesText = UITextView()
    private lazy var collectionOfWords: UICollectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - init
    
    init(memo: Memo) {
        self.vm = MemoDetailViewModel(memo: memo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTitleTF()
        setUpNotesTV()
        setUpStackView()
        setUpCollection()
    }
    
    // MARK: - Set Up views
    
    func setUpView() {
        navigationItem.title = "Memo"
        view.backgroundColor = .systemBackground
    }
    
    func setUpTitleTF() {
        titleLabel.text = vm.getMemoTitle()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    }
    
    func setUpNotesTV() {
        notesText.text = vm.getMemoNotes()
        notesText.font = UIFont.systemFont(ofSize: 16.0)
        notesText.textColor = .secondaryLabel
        notesText.isEditable = false
    }
    
    func setUpCollection() {
        collectionOfWords.dataSource = self
        collectionOfWords.delegate = self
        collectionOfWords.register(WordDetailCollectionCell.self, forCellWithReuseIdentifier: WordDetailCollectionCell.identifier)
    }
    
    func setUpStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(titleLabel)
        if !notesText.text.isEmpty {
            stackView.addArrangedSubview(notesText)
        }
        
        stackView.addArrangedSubview(collectionOfWords)
        view.addSubview(stackView)
        
        notesText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        notesText.widthAnchor.constraint(equalToConstant: stackView.bounds.width).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.getWordCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionOfWords.dequeueReusableCell(
            withReuseIdentifier: "wordcollectioncell",
            for: indexPath
        ) as? WordDetailCollectionCell ?? UICollectionViewCell()
        if let cell = cell as? WordDetailCollectionCell {
            cell.setUpAppearance(title: vm.getWord(at: indexPath.row).capitalized)
            cell.isUserInteractionEnabled = true
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedWordVC = ArticleDetailViewController(word: vm.getArticle(for: indexPath.row))
        self.navigationController?.pushViewController(detailedWordVC, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 2.4 , height: view.bounds.height / 10)
    }

    
}
