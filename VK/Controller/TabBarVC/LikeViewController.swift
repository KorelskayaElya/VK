//
//  SavedViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit
protocol LikeViewControllerDelegate: AnyObject {
    func likeViewControllerDidTapLikeSaveWith(_ post: PostEntity)
}

class LikeViewController: UIViewController, PostTableViewCellLikeDelegate {

    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "LikePostCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    // MARK: -  Properties
    var likedPosts: [PostEntity] = []
    weak var delegate: LikeViewControllerDelegate?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }
   // MARK: - Private
    private func setupView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    /// обновить таблицу
    private func reload() {
        likedPosts = CoreDataService.shared.getLikedPosts()
        tableView.reloadData()
    }
    /// убрать пост
    func postTableViewCellDidTapLikeSaveWith(_ post: PostEntity) {
        post.isLikedByCurrentUser.toggle()
        CoreDataService.shared.saveContext()
        
        if let index = likedPosts.firstIndex(of: post) {
            likedPosts.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        CoreDataService.shared.reloadPosts()
        tableView.reloadData()
        
        delegate?.likeViewControllerDidTapLikeSaveWith(post)
    }
    

}
extension LikeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPosts.count
    }
    /// посты
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikePostCell", for: indexPath) as? PostTableViewCell else {
            fatalError("Could not dequeue a LikePostTableViewCell")
        }
        
        var post = likedPosts[indexPath.row]
        cell.configure(with: post,
                       textFont: UIFont(name: "Arial", size: 14)!,
                       contentWidth: tableView.frame.width - 100)
        cell.delegate = self
        
        return cell
    }
    /// высота поста
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikePostCell") as! PostTableViewCell
        let post = likedPosts[indexPath.row]
        var image: UIImage?
        if let imageData = post.imagePost {
            image = UIImage(data: imageData)
        }

        /// ширина  контента
        let contentWidth = tableView.frame.width - 100
        /// динамичное отображение высоты текста в посте
        let textHeight = cell.calculateTextHeight(text: post.textPost ?? "", font: UIFont(name: "Arial", size: 14)!, width: contentWidth)
        /// динамичное отображение высоты изображения в посте
        let imageHeight = cell.calculateImageHeight(image: image, width: contentWidth)
        /// приблизительные размеры под элементы
        let timeHeight: CGFloat = 20
        let avatarHeight: CGFloat = 40
        let nameLabelHeight: CGFloat = 20
        let descriptionLabelHeight: CGFloat = 20
        let otherViewHeights: CGFloat = 90
        /// сколько всего занимает высоты пост
        let totalHeight = textHeight + imageHeight + timeHeight + avatarHeight + nameLabelHeight + descriptionLabelHeight + otherViewHeights
        
        return totalHeight
    }
}
    
