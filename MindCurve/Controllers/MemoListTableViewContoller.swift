//
//  MemoListTableViewController.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 22.08.2023.
//

import UIKit
import Combine

protocol MemoDelegate {
    func memoWasCreated(memo: Memo)
}

class MemoListTableViewContoller: UIViewController, UITableViewDataSource, UITableViewDelegate, MemoDelegate {
    
    private let vm: MemoListViewModel = MemoListViewModel()
    let welcomeButton = UIButton()
    private var cancellables: Set<AnyCancellable> = []
    private var memoTableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.$memos
            .sink(receiveValue: { [weak self] _ in
                self?.memoTableView.reloadData()
            })
            .store(in: &cancellables)

        setUpView()
        setUpTableView()
        if isTableViewEmpty(tableView: memoTableView) { setUpWelcomeScreen() }
        setUpNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if memoTableView.isEditing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editButtonTapped))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        }
    }
      
    // MARK: - Set up views
    
    func setUpView() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Memo List"
    }
    
    func setUpTableView() {
        memoTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(memoTableView)
        NSLayoutConstraint.activate([
            memoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        memoTableView.dataSource = self
        memoTableView.delegate = self
    }
    
    func setUpWelcomeScreen() {
        welcomeButton.setTitle("Add your first memo 📝", for: .normal)
        welcomeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        welcomeButton.layer.backgroundColor = UIColor.systemIndigo.cgColor
        welcomeButton.layer.shadowRadius = 5
        welcomeButton.layer.shadowOpacity = 0.3
        welcomeButton.layer.shadowOffset = .init(width: 5, height: 5)
        welcomeButton.layer.shadowColor = UIColor.systemBlue.cgColor
        welcomeButton.layer.cornerRadius = 5
        
        welcomeButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        UIButton.animate(withDuration: 3, delay: 0.0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            self.welcomeButton.backgroundColor = UIColor.systemBlue
            self.welcomeButton.layer.shadowColor = UIColor.systemIndigo.cgColor
        }, completion: nil)
        
        welcomeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeButton)
        welcomeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        welcomeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        welcomeButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    
    func setUpNavigation() {
        navigationItem.rightBarButtonItem = .init(image: .init(systemName: "plus.circle"), style: .plain, target: self, action: #selector(plusButtonTapped))
        
        let customBarButtonItem: UIBarButtonItem = {
            let editButton = UIButton(type: .system)
            editButton.setTitle("Edit", for: .normal)
            editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            return UIBarButtonItem(customView: editButton)
        }()
        navigationItem.leftBarButtonItem = customBarButtonItem
    }
    
    // MARK: - @objc functions
    
    @objc func editButtonTapped() {
        memoTableView.isEditing = !memoTableView.isEditing
    }
    
    @objc func plusButtonTapped() {
        let createMemoView = CreateMemoViewController()
        createMemoView.delegate = self
        let nav = UINavigationController(rootViewController: createMemoView)
        self.present(nav, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.memosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MemoTableViewCell.identifier,
            for: indexPath
        ) as? MemoTableViewCell ?? UITableViewCell()
        if let cell = cell as? MemoTableViewCell {
            cell.setUpContent(text: vm.getMemoName(at: indexPath.row))
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoDetailView = MemoDetailViewController(memo: vm.getMemo(at: indexPath.row))
        self.navigationController?.pushViewController(memoDetailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            vm.deleteMemo(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if isTableViewEmpty(tableView: tableView) {
                welcomeButton.isHidden = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        vm.swapMemos(firstIndex: sourceIndexPath.row, secondIndex: destinationIndexPath.row)
    }
    
    func memoWasCreated(memo: Memo) {
        vm.addMemo(memo: memo)
        memoTableView.reloadData()
        welcomeButton.isHidden = true
    }
    
    func isTableViewEmpty(tableView: UITableView) -> Bool {
        let sections = tableView.numberOfSections
        for section in 0..<sections {
            let rows = tableView.numberOfRows(inSection: section)
            if rows > 0 {
                return false
            }
        }
        return true
    }

}

