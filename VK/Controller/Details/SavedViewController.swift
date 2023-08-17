//
//  SavedViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit
// закладки
class SavedViewController: UIViewController {
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "SavedPostCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    // MARK: - Properties
    var savedPosts: [Post] = []
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        title = "Закладки".localized
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.backgroundColor = .systemBackground
    }
    // MARK: - Private
    private func setupView() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
extension SavedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPostCell", for: indexPath) as? PostTableViewCell else {
            fatalError("Could not dequeue a SavedPostTableViewCell")
        }
        
        let post = self.savedPosts[indexPath.row]
        //cell.configure(with: post.imagePost)
        //cell.delegate = self
        
        return cell
    }
    
//    func postTableViewCellDidTapSave(_ cell: PostTableViewCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        var post = likedPosts[indexPath.row]
//        post.isLikedByCurrentUser.toggle()
//        likedPosts[indexPath.row] = post
//
//        if post.isLikedByCurrentUser {
//            likedPosts.remove(at: indexPath.row)
//            savedPosts.append(post)
//
//        }
//        tableView.reloadData()
//    }
}

