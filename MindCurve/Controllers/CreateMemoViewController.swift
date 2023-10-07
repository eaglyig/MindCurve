//
//  CreateMemoViewController.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 29.09.2023.
//

import UIKit
import Combine

class CreateMemoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, WordArticleFetchDelegate {

    struct Constants {
        static let font = UIFont.systemFont(ofSize: 16)
        static let textColor = UIColor.black
        static let bgColor = UIColor.secondarySystemBackground
    }
    
    private let vm = CreateMemoViewModel()
    
    private var importanceControl = UISegmentedControl()
    private let addWordLabel = UILabel()
    private let memoTitleTF = UITextField()
    private let memoNotesTV = UITextView()
    private let newWordTF = UITextField()
    private let addButton = UIButton()
    private let tableViewOfWords = {
        let table = UITableView()
        table.register(WordTableViewCell.self, forCellReuseIdentifier: WordTableViewCell.identifier)
        return table
    }()
    private let memoNotesPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "Put some notes here (optional):"
        label.font = Constants.font
        return label
    }()
    private let titleNotesStack: UIStackView = UIStackView()
    private let wordAddStack: UIStackView = UIStackView()
    weak var delegate: MemoListTableViewContoller?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        setUpView()
        setUpStackWithNameAndNotes()
        setUpImportanceControl()
        setUpStackWithWordAdding()
        setUpTableView()
    }
    
    // MARK: - Set up views
    
    /// Sets up parent view & navigation bar
    private func setUpView() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Add Memo"
        self.navigationItem.titleView?.tintColor = .blue
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        cancelButton.tintColor = .red
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func setUpStackWithNameAndNotes() {
        prepareTextField(as: memoTitleTF, at: titleNotesStack, with: "Enter title:", taggedWith: 1)
        
        memoNotesTV.translatesAutoresizingMaskIntoConstraints = false
        memoNotesTV.tag = 1
        memoNotesTV.layer.cornerRadius = 5
        memoNotesTV.textColor = .black
        memoNotesTV.backgroundColor = Constants.bgColor
        memoNotesTV.font = Constants.font
        memoNotesTV.addSubview(memoNotesPlaceholder)
        memoNotesTV.delegate = self
        memoNotesPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        memoNotesPlaceholder.textColor = .lightGray
        memoNotesPlaceholder.topAnchor.constraint(equalTo: memoNotesTV.topAnchor, constant: 8).isActive = true
        memoNotesPlaceholder.leadingAnchor.constraint(equalTo: memoNotesTV.leadingAnchor, constant: 5).isActive = true
        
        titleNotesStack.addArrangedSubview(memoNotesTV)
        titleNotesStack.translatesAutoresizingMaskIntoConstraints = false
        titleNotesStack.axis = .vertical
        titleNotesStack.spacing = 10
        titleNotesStack.alignment = .fill
        titleNotesStack.distribution = .fill
        self.view.addSubview(titleNotesStack)
        
        NSLayoutConstraint.activate([
            titleNotesStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleNotesStack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            titleNotesStack.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            titleNotesStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            memoTitleTF.topAnchor.constraint(equalTo: self.titleNotesStack.topAnchor),
            memoTitleTF.widthAnchor.constraint(greaterThanOrEqualToConstant: self.titleNotesStack.frame.width / 2),
            memoTitleTF.heightAnchor.constraint(equalToConstant: 40),
            
            memoNotesTV.topAnchor.constraint(equalTo: self.memoTitleTF.bottomAnchor, constant: 30),
            memoNotesTV.widthAnchor.constraint(greaterThanOrEqualToConstant: self.titleNotesStack.frame.width / 2),
            memoNotesTV.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    private func setUpImportanceControl() {
        importanceControl = UISegmentedControl(items: vm.getMemoStates())
        importanceControl.selectedSegmentIndex = 0
        importanceControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(importanceControl)
        
        importanceControl.topAnchor.constraint(equalTo: titleNotesStack.bottomAnchor, constant: 15).isActive = true
        importanceControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        importanceControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        importanceControl.addTarget(self, action: #selector(importanceControlValueChanged(_:)), for: .valueChanged)
    }
    
    /// Sets up appearance & layout of a stack view for text field and add button
    private func setUpStackWithWordAdding() {
        prepareTextField(as: newWordTF, at: wordAddStack, with: "Enter word:", taggedWith: 2)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.systemBlue, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.wordAddStack.addArrangedSubview(addButton)
        
        wordAddStack.translatesAutoresizingMaskIntoConstraints = false
        wordAddStack.axis = .horizontal
        wordAddStack.spacing = 10
        wordAddStack.alignment = .fill
        wordAddStack.distribution = .fill
        self.view.addSubview(wordAddStack)
        
        NSLayoutConstraint.activate([
            wordAddStack.topAnchor.constraint(equalTo: self.importanceControl.bottomAnchor, constant: 15),
            wordAddStack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            wordAddStack.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            wordAddStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            newWordTF.leadingAnchor.constraint(equalTo: self.wordAddStack.leadingAnchor),
            newWordTF.widthAnchor.constraint(greaterThanOrEqualToConstant: self.wordAddStack.frame.width / 2),
            newWordTF.heightAnchor.constraint(equalToConstant: 40),
            addButton.leadingAnchor.constraint(equalTo: newWordTF.trailingAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setUpTableView() {
        tableViewOfWords.dataSource = self
        tableViewOfWords.delegate = self
        
        self.view.addSubview(tableViewOfWords)
        tableViewOfWords.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewOfWords.topAnchor.constraint(equalTo: self.wordAddStack.bottomAnchor, constant: 20),
            tableViewOfWords.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            tableViewOfWords.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            tableViewOfWords.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - @objc functions
    
    @objc private func addButtonPressed() {
        guard let text = newWordTF.text, !text.isEmpty else { return }
        newWordTF.text = ""
        vm.pushWord(word: text)
    }
    
    @objc func importanceControlValueChanged(_ sender: UISegmentedControl) {
        vm.setMemoState(memoPosition: sender.selectedSegmentIndex)
    }
    
    @objc private func doneButtonPressed() {
        delegate?.memoWasCreated(memo: vm.getMemo())
        dismiss(animated: true)
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField.tag {
        case 1: vm.setTitle(title: textField.text ?? "")
        default: break
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getWordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOfWords.dequeueReusableCell(
            withIdentifier: "wordcell",
            for: indexPath
        ) as? WordTableViewCell ?? UITableViewCell()
        if let cell = cell as? WordTableViewCell {
            cell.setUpContent(text: vm.getWord(at: indexPath.row).capitalized)
        }
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholderLabel.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.placeholderLabel.isHidden = false
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        memoNotesPlaceholder.alpha = 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text?.isEmpty ?? true {
            memoNotesPlaceholder.alpha = 1
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case 1: vm.setNotes(notes: textView.text ?? "")
        default: break
        }
    }
    
    // MARK: - Functions that facilitate UI-processing code
    
    private func prepareTextField(as textField: UITextField, at stackView: UIStackView, with placeholder: String, taggedWith tag: Int) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = Constants.font
        textField.backgroundColor = Constants.bgColor
        textField.placeholder = placeholder
        textField.tag = tag
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        stackView.addArrangedSubview(textField)
    }
    
    static private func preparePlaceholder(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.lightGray
        label.font = Constants.font
        return label
    }
    
    // MARK: - WordArticleFetchDelegate
    
    func dataDidUpdate(data: WordArticle) {
        let indexPath = IndexPath(row: vm.getWordCount() - 1, section: 0)
        tableViewOfWords.insertRows(at: [indexPath], with: .automatic)
        tableViewOfWords.reloadData()
    }
}

extension UITextField {
    var placeholderLabel: UILabel {
        let label = UILabel()
        label.text = placeholder
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return label
    }
}

