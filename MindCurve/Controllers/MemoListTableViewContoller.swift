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
        setUpNavigation()
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
    
    func memoWasCreated(memo: Memo) {
        vm.addMemo(memo: memo)
        memoTableView.reloadData()
    }
}

