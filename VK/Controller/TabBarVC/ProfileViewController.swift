//
//  ProfileViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit
import KeychainAccess
protocol ProfileAddPhotoViewControllerDelegate: AnyObject {
    func profileAddPhotoViewController(_ selectedImage: UIImage)
}
class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
                                ButtonDelegate, SearchBarDelegate, ProfileTableHeaderViewDelegate,
                             PostAddViewControllerDelegate, ProfileCameraDelegate, ProfileEditDelegate,
                             ProfileAddPhotoDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                             EditMainInformationDelegate, ProfileFurtherInformationDelegate{
   
    
    func editMainInformation() {
        print("info__________________")
        let vc = InformationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    weak var profileAddPhotoDelegate: ProfileAddPhotoViewControllerDelegate?
    var selectedImage: UIImage = UIImage()
    var isOpenEdit = false
    var isOpenDetails = false
    func didAddPhoto() {
        ImagePicker.defaultPicker.getImage(in: self)
        print("select image", selectedImage)
        let viewModel = PhotoViewModel(model: Photo.photos)
        let photosViewController = PhotosViewController()
        photosViewController.viewModel = viewModel
        photosViewController.profileAddPhotoViewController(selectedImage)
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    // фильтрация
    var isFiltering: Bool = false
    var user: User
    var allPosts: [Post] = []
    var filteredPosts: [Post] = []
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let profileId = UILabel()
        profileId.text = user.identifier
        profileId.font = UIFont.boldSystemFont(ofSize: 17.0)
        profileId.textColor = UIColor.black
        let outIcon = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                      style: .done, target: self, action: #selector(didOut))
        outIcon.tintColor = UIColor.black
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: profileId),outIcon]

        let menuIcon = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                       style: .done, target: self, action: #selector(openMenu))
        menuIcon.tintColor = UIColor(named: "Orange")
        navigationItem.rightBarButtonItem = menuIcon
        setupView()
        allPosts = loadPostsFromStringsFile()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        //tableView.backgroundColor = .systemBackground
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(SearchBarTableViewCell.self, forCellReuseIdentifier: "SearchBarCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func createHeaderView() -> UIView {
        let headerView = ProfileTableHeaderView()
        headerView.nameLabel.text = user.username
        headerView.descriptionLabel.text = "дизайнер"
        headerView.delegate = self
        headerView.cameraDelegate = self
        headerView.editProfileDelegate = self
        headerView.addPhotoDelegate = self
        headerView.editProfileDelegate = self
        headerView.furtherInformation = self
        let containerView = UIView()
        containerView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        return containerView
    }

    private func setupView() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    // переход на вью изображения
//    func didTapButton(sender: UIButton) {
//        let viewModel = PhotoViewModel(model: Photo.photos)
//        let photosViewController = PhotosViewController()
//        photosViewController.viewModel = viewModel
//        photosViewController.profileAddPhotoViewController(selectedImage)
//        navigationController?.pushViewController(photosViewController, animated: true)
//    }
    func didTapButton(sender: UIButton) {
        let viewModel = PhotoViewModel(model: Photo.photos)
        let photosViewController = PhotosViewController()
        photosViewController.viewModel = viewModel
        navigationController?.pushViewController(photosViewController, animated: true)
    }

    // создать новый пост из postAddvc
    func didTapCreatePost() {
        let vc = PostAddViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    // включить камеру для истории
    func didTapCamera() {
        let vc = CameraViewController()
        print("didtapcamera")
        navigationController?.pushViewController(vc, animated: true)
    }
    // подробная информация
    func didFurtherInformation() {
        let vc = FurtherInformationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    // передать видео 
    func cameraViewControllerDidRecordVideo(_ viewController: CameraViewController, videoURL: URL) {
         
    }
    // переход на редактирование профиля / должен открываться один из модальных экранов
    // в соответствии с флагом - EditProfilePresentationController
    func didEditProfile() {
        isOpenDetails = false
        isOpenEdit = true
        let halfScreenWidth = UIScreen.main.bounds.width * 3 / 4
        let halfScreenViewController = UIViewController()
        halfScreenViewController.view.backgroundColor = .white
        halfScreenViewController.modalPresentationStyle = .custom
        halfScreenViewController.transitioningDelegate = self
        halfScreenViewController.preferredContentSize = CGSize(width: halfScreenWidth, height: UIScreen.main.bounds.height)
        present(halfScreenViewController, animated: true, completion: nil)
    }
    // обновить таблицу после нового поста
    func postAddViewController(_ controller: PostAddViewController, didCreatePost post: Post) {
        // добавление поста сверху
        allPosts.insert(post, at: 0)
        tableView.reloadData()
    }
    func didTapCreatePost(image: UIImage, text: String) {
       let user = User(identifier: "annaux_desiner", username: "Анна Мищенко", profilePicture: UIImage(named: "header1"), status: "дизайнер")
       let newPost = Post(user: user, textPost: text, imagePost: image)
       allPosts.append(newPost)
       tableView.reloadData()
   }
    
    // количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    // количество ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return isFiltering ? filteredPosts.count : allPosts.count
        }
    }
    // header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return createHeaderView()
        } else {
            return nil
        }
    }
    
    // размер секции
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 390
        } else if section == 2 {
            return 0
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosTableViewCell
            let viewModel = PhotosTableViewCell.ViewModel(title: "Photos", image: nil)
            cell.delegate = self
            cell.setup(with: viewModel)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarCell", for: indexPath) as! SearchBarTableViewCell
            cell.searchBarDelegate = self
            cell.configure(with: SearchBarModel(placeholder: "Мои записи"))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            let post = isFiltering ? filteredPosts[indexPath.row] : allPosts[indexPath.row]
            cell.configure(with: post)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 120
        } else if indexPath.section == 2 {
            return 60
        } else {
            return 400
        }
    }
    // поиск по словам в посте
    func searchBarDidChange(_ searchText: String) {
        if searchText.isEmpty {
            isFiltering = false
            tableView.reloadData()
        } else {
            isFiltering = true
            filteredPosts = allPosts.filter { post in
                return post.textPost.lowercased().contains(searchText.lowercased())
            }
            tableView.reloadData()
        }
    }
    // убрать клавиатуру
    func searchBarSearchButtonTapped() {
        dismissKeyboard()
    }
    // отмена клавиатуры
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    // локальные посты из postfile
    func loadPostsFromStringsFile() -> [Post] {
        guard let path = Bundle.main.path(forResource: "postfile", ofType: "strings"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
          let dictionary = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
          let postArray = dictionary["post"] as? [[String: Any]] else {
        return []
        }

        var posts: [Post] = []

        for postDict in postArray {
            if let textPost = postDict["textPost"] as? String,
               let imagePostName = postDict["imagePost"] as? String,
               let imagePost = UIImage(named: imagePostName) {
                let user = User(identifier: "annaux_desiner", username: "Анна Мищенко", profilePicture: UIImage(named: "header1"), status: "дизайнер")
                let post = Post(user: user, textPost: textPost, imagePost: imagePost)
                posts.append(post)
            }
        }
        print(posts)

        return posts
    }
    // кнопка выхода
    @objc func didOut() {
        let actionSheet = UIAlertController(title: "Sign Out",
                                            message: "Would you like to sign out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
                AuthManager.shared.signOut { success in
                    if success {
                        UserDefaults.standard.setValue(nil, forKey: "phoneNumber")
                        KeychainManager.shared.saveSignInFlag(false)
                        
                        // здесь должен быть преход на welcomevc
                        
                    } else {
                        // failed
                        let alert = UIAlertController(title: "Woops",
                                                      message: "Something went wrong when signing out. Please try again.",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    // переход на редактирование профиля / должен открываться один из модальных экранов
    // в соответствии с флагом - HalfScreenPresentationController
    @objc func openMenu() {
        isOpenEdit = false
        isOpenDetails = true
        let halfScreenWidth = UIScreen.main.bounds.width * 3 / 4
        let halfScreenViewController = UIViewController()
        halfScreenViewController.view.backgroundColor = .white
        halfScreenViewController.modalPresentationStyle = .custom
        halfScreenViewController.transitioningDelegate = self
        halfScreenViewController.preferredContentSize = CGSize(width: halfScreenWidth, height: UIScreen.main.bounds.height)
        
        present(halfScreenViewController, animated: true, completion: nil)
    }

}

extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if isOpenEdit == true && isOpenDetails == false {
            return EditProfilePresentationController(presentedViewController: presented, presenting: presenting, user: user)
        } else if isOpenEdit == false && isOpenDetails == true {
            return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting, user: user)
        } else {
            return nil
        }
    }
}
