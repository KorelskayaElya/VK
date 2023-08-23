//
//  SavedViewController.swift
//  VK
//
//  Created by Эля Корельская on 14.08.2023.
//

import UIKit
protocol SaveViewControllerDelegate: AnyObject {
    func saveViewControllerDidTapSaveWith(_ post: PostEntity)
}
/// закладки
class SavedViewController: UIViewController, PostTableViewCellSaveDelegate {
    
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
    var savedPosts: [PostEntity] = []
    weak var delegate: SaveViewControllerDelegate?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        title = "Saved".localized
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.backgroundColor = .systemBackground
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
    /// выйти назад
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    /// перезагрузить
    private func reload() {
        savedPosts = CoreDataService.shared.getSavedPosts()
        tableView.reloadData()
    }
    /// убрать пост из закладок
    func postTableViewCellDidTapSavePostWith(_ post: PostEntity) {
        post.isSavedByCurrentUser.toggle()
        CoreDataService.shared.saveContext()
        
        if let index = savedPosts.firstIndex(of: post) {
            savedPosts.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        CoreDataService.shared.reloadPosts()
        tableView.reloadData()
        
        delegate?.saveViewControllerDidTapSaveWith(post)
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
        
        var post = savedPosts[indexPath.row]
        cell.saveDelegate = self
        cell.configure(with: post,
                       textFont: UIFont(name: "Arial", size: 14)!,
                       contentWidth: tableView.frame.width - 100)
        return cell
    }
    /// высота поста
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPostCell") as! PostTableViewCell
        let post = savedPosts[indexPath.row]
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
