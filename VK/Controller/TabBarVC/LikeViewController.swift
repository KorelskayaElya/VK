//
//  SavedViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit

// liked publications
class LikeViewController: UIViewController {
    
    // MARK: UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "LikePostCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    // MARK: Properties
    var likedPosts: [Post] = []
    var savedPosts: [Post] = []
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }
   // MARK: Private
    private func setupView() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

}
extension LikeViewController: UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikePostCell", for: indexPath) as? PostTableViewCell else {
            fatalError("Could not dequeue a LikePostTableViewCell")
        }
        
        let post = self.likedPosts[indexPath.row]
        //cell.configure(with: post.imagePost)
        cell.delegate = self
        
        return cell
    }
    
    func postTableViewCellDidTapLike(_ cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var post = self.likedPosts[indexPath.row]
        post.isLikedByCurrentUser.toggle()
        self.likedPosts[indexPath.row] = post
        
        if post.isLikedByCurrentUser {
            self.likedPosts.remove(at: indexPath.row)
            self.savedPosts.append(post)
            
        }
        tableView.reloadData()
    }
}
