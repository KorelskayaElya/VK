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

protocol ProfileViewControllerDelegate: AnyObject {
    func welcomeViewControllerSignOutTapped()
}

class ProfileViewController: UIViewController, ProfileTableViewCellDelegate, ProfileTableHeaderAddPostViewDelegate {
    
    
   // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(SearchBarTableViewCell.self, forCellReuseIdentifier: "SearchBarCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    /// создать шапку профиля
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
        let profileViewModel = ProfileHeaderViewModel(user: User(identifier: "annaux_designer", username: "Анна Мищенко", profilePicture: UIImage(named:"header1"), status: "дизайнер",gender: "Женский", birthday: "01.02.1997", city: "Москва",hobby: "футбол",school:"Дизайнер", university: "школа 134", work: "Московский"), followerCount: 4, followingCount: 5, isFollowing: false, publishedPhotos: allPosts.count)
        headerView.configure(with: profileViewModel)
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
   
    
    // MARK: Properties
    /// делегат для добавления изображения в photovc
    weak var profileAddPhotoDelegate: ProfileAddPhotoViewControllerDelegate?
    /// делегат для выхода из аккаунта
    weak var delegate: ProfileViewControllerDelegate?
    /// для сохранения выбора изображения
    var selectedImage: UIImage = UIImage()
    /// открытие того или другого presentationcontroller
    var isOpenEdit = false
    var isOpenDetails = false
    var isAnotherUser = false
    
    private var posts = [Post]()
    private var followers = [String]()
    private var following = [String]()
    private var isFollower: Bool = false
    var user: User
    /// для показа отфильрованных постов и всех постов
    var isFiltering: Bool = false
    var allPosts: [Post] = []
    var filteredPosts: [Post] = []
    var likedPosts: [Post] = []
    var savedPosts: [Post] = []
    /// получение данных для подробной информации
    var receivedUsername: String = ""
    var receivedGender: String = ""
    var receivedBirthday: String = ""
    var receivedCity: String = ""
    var receivedHobby: String = ""
    var receivedSchool: String = ""
    var receivedUniversity: String = ""
    var receivedWork: String = ""
    var receivedStatus: String = ""
    
    
    // MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let profileId = UILabel()
        profileId.text = user.identifier
        profileId.font = UIFont.boldSystemFont(ofSize: 17.0)
        profileId.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        let outIcon = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                      style: .done, target: self, action: #selector(didOut))
        outIcon.tintColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: profileId),outIcon]

        let menuIcon = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                       style: .done, target: self, action: #selector(openMenu))
        if #available(iOS 16.0, *) {
            menuIcon.isHidden = false
            outIcon.isHidden = false
        } else {
           print("error hidden")
        }
        /// когда пользователь будет попадать на страницу к другому поьзователю
        /// скрываются кнопки
        if isAnotherUser == true {
            if #available(iOS 16.0, *) {
                menuIcon.isHidden = true
                outIcon.isHidden = true
            } else {
               print("error hidden")
            }
        }
        menuIcon.tintColor = UIColor(named: "Orange")
        navigationItem.rightBarButtonItem = menuIcon
        setupView()
        allPosts = loadPostsFromStringsFile()
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
    // MARK: - Methods
    /// переход на фотографии
    func didTapButton(sender: UIButton) {
        let viewModel = PhotoViewModel(model: Photo.photos)
        let photosViewController = PhotosViewController()
        //photosViewController.viewModel = viewModel
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    /// кнопка выхода
    @objc func didOut() {
        let actionSheet = UIAlertController(title: "Sign Out".localized,
                                            message: "Would you like to sign out?".localized,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out".localized, style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
                AuthManager.shared.signOut { success in
                    if success {
                        UserDefaults.standard.setValue(nil, forKey: "phoneNumber")
                        KeychainManager.shared.saveSignInFlag(false)
                        self?.delegate?.welcomeViewControllerSignOutTapped()
                        print("### You have to get out")
                    } else {
                        // failed
                        let alert = UIAlertController(title: "Woops".localized,
                                                      message: "Something went wrong when signing out. Please try again.".localized,
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }


    /// переход на редактирование профиля / должен открываться один из модальных экранов
    /// в соответствии с флагом - HalfScreenPresentationController
    @objc private func openMenu() {
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
/// таблица из 4-х секций:
/// шапка профиля
/// фотографии
/// searchbar
/// посты
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate, SearchBarDelegate  {
    /// поиск по словам в посте
    func searchBarDidChange(_ searchText: String) {
        /// если текста нет обновить обратно до полного списка
        if searchText.isEmpty {
            isFiltering = false
            tableView.reloadData()
        } else {
            /// если текст есть то отфильровать по этому тексту и
            /// обновить когда текст уже будет написан
            isFiltering = true
            filteredPosts = allPosts.filter { post in
                post.textPost.lowercased().contains(searchText.lowercased())
            }
        }
    }
    /// при окончании набора текста обновить таблицу
    func searchBarSearchButtonTapped() {
        if view.endEditing(true) {
            tableView.reloadData()
        }
    }
    /// количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    /// количество ячеек в секции
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
    /// header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return createHeaderView()
        } else {
            return nil
        }
    }
    
    /// размер секции
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
            cell.configure(with: SearchBarModel(placeholder: "My Posts".localized))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            let post = isFiltering ? filteredPosts[indexPath.row] : allPosts[indexPath.row]
            cell.configure(with: post, textFont: UIFont(name: "Arial", size: 14)!, contentWidth: tableView.frame.width - 100)
            /// для лайка
            cell.delegate = self
            /// для сохранения поста
            cell.saveDelegate = self
            /// удаление поста
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
                self?.deletePost(at: indexPath)
                completionHandler(true)
            }
            deleteAction.backgroundColor = .red
            deleteAction.image = UIImage(systemName: "trash.fill")
            
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 120
        } else if indexPath.section == 2 {
            return 60
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
            let post = isFiltering ? filteredPosts[indexPath.row] : allPosts[indexPath.row]
            /// шрифт текста
            let textFont = UIFont(name: "Arial", size: 14)!
            /// ширина  контента
            let contentWidth = tableView.frame.width - 100
            /// динамичное отображение высоты текста в посте
            let textHeight = cell.calculateTextHeight(text: post.textPost, font: textFont, width: contentWidth)
            /// динамичное отображение высоты изображения в посте
            let imageHeight = cell.calculateImageHeight(image: post.imagePost, width: contentWidth)
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
    /// удаление поста
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePost(at: indexPath)
        }
    }
    /// удаление поста
    func deletePost(at indexPath: IndexPath) {
        if isFiltering {
            filteredPosts.remove(at: indexPath.row)
        } else {
            allPosts.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

}
extension ProfileViewController: ProfileFurtherInformationDelegate {
    /// подробная информация
    func didFurtherInformation() {
        let vc = FurtherInformationViewController()
        vc.receivedUsername = receivedUsername
        vc.receivedGender = receivedGender
        vc.receivedBirthday = receivedBirthday
        vc.receivedCity = receivedCity
        vc.receivedHobby = receivedHobby
        vc.receivedSchool = receivedSchool
        vc.receivedUniversity = receivedUniversity
        vc.receivedWork = receivedWork
        vc.receivedStatus = receivedStatus
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ProfileViewController: UIViewControllerTransitioningDelegate, InformationViewControllerDelegate,  WorkViewControllerDelegate, EducationViewControllerDelegate, HobbyViewControllerDelegate {
    /// передать напечатанную информацию в подробую информацию
    func informationViewControllerDidFinishEnteringInfo(username: String, gender: String, birthday: String, city: String, status: String) {
        receivedUsername = username
        receivedGender = gender
        receivedBirthday = birthday
        receivedCity = city
        receivedStatus = status
        user.username = receivedUsername
        user.gender = receivedGender
        user.birthday = receivedBirthday
        user.city = receivedCity
        user.status = receivedStatus
    }
    /// передать напечатанную информацию в подробую информацию
    func workViewControllerDidFinishEnteringInfo(work: String) {
        receivedWork = work
        user.work = receivedWork
    }
    /// передать напечатанную информацию в подробую информацию
    func educationViewControllerDidFinishEnteringInfo(school: String, university: String) {
        receivedSchool = school
        receivedUniversity = university
        user.school = receivedSchool
        user.university = receivedUniversity
    }
    /// передать напечатанную информацию в подробую информацию
    func hobbyViewControllerDidFinishEnteringInfo(hobby: String) {
        receivedHobby = hobby
        user.hobby = receivedHobby
    }
    /// полуэкраны
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if isOpenEdit == true && isOpenDetails == false {
            let presentationController = EditProfilePresentationController(presentedViewController: presented, presenting: presenting, user: user)
            presentationController.editMainInformationDelagete = self
            presentationController.editWorkDelegate = self
            presentationController.editEducationDelegate = self
            presentationController.editHobbyDelegate = self
            return presentationController
            
        } else if isOpenEdit == false && isOpenDetails == true {
            let presentationController = DetailsProfilePresentationController(presentedViewController: presented, presenting: presenting, user: user)
            presentationController.detailsProfileToSaveDelegate = self
            presentationController.detailsProfileToFilesDelagate = self
            return presentationController
        } else {
            return nil
        }
    }
        
}

extension ProfileViewController: EditMainInformationDelegate,EditEducationDelegate, EditWorkDelegate, EditHobbyDelegate {
    /// основная информация
    func editMainInformation() {
        let infoVC = InformationViewController(user: user)
        infoVC.delegate = self
        navigationController?.pushViewController(infoVC, animated: true)
    }
    /// карьера
    func editWork() {
        let workVC = WorkViewController(user: user)
        workVC.delegate = self
        navigationController?.pushViewController(workVC, animated: true)
    }
    /// инетересы
    func editHobby() {
        let hobbyVC = HobbyViewController(user:user)
        hobbyVC.delegate = self
        navigationController?.pushViewController(hobbyVC, animated: true)
    }
    /// образование
    func editEducation() {
        let educationVC = EducationViewController(user:user)
        educationVC.delegate = self
        navigationController?.pushViewController(educationVC, animated: true)
    }
}
extension ProfileViewController: DetailsProfileToSaveDelegate, DetailsProfileToFilesDelegate {
    /// файлы
    func detailsProfileToFiles() {
        let filesVC = FilesViewController()
        navigationController?.pushViewController(filesVC, animated: true)
    }
    /// закладки
    func detailsProfileToSave() {
        let saveVC = SavedViewController()
        saveVC.updateSavedPosts(savePosts: savedPosts)
        navigationController?.pushViewController(saveVC, animated: true)
    }
}
extension ProfileViewController: ProfileCameraDelegate {
    /// включить камеру для истории
    func didTapCamera() {
        let vc = CameraViewController()
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ProfileViewController: ProfileAddPhotoDelegate {
    func didAddPhoto() {
        ImagePicker.defaultPicker.getImage(in: self)
        print("select image", selectedImage)
        let viewModel = PhotoViewModel(model: Photo.photos)
        let photosViewController = PhotosViewController()
        //photosViewController.viewModel = viewModel
        photosViewController.profileAddPhotoViewController(selectedImage)
        navigationController?.pushViewController(photosViewController, animated: true)
    }
}
extension ProfileViewController: ProfileEditDelegate {
    ///переход на редактирование профиля / должен открываться один из модальных экранов
    /// в соответствии с флагом - EditProfilePresentationController
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
}
extension ProfileViewController: PostAddViewControllerDelegate {
    /// создать новый пост из postAddvc
    func didTapCreatePost() {
        let vc = PostAddViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    /// обновить таблицу после нового поста
    func postAddViewController(_ controller: PostAddViewController, didCreatePost post: Post) {
        // добавление поста сверху
        allPosts.insert(post, at: 0)
        tableView.reloadData()
    }
    func didTapCreatePost(image: UIImage, text: String) {
        let user = User(identifier: "annaux_designer", username: "Анна Мищенко", profilePicture: UIImage(named:"header1"), status: "дизайнер",gender: "Женский", birthday: "01.02.1997", city: "Москва",hobby: "футбол",school:"Дизайнер", university: "школа 134", work: "Московский")
       let newPost = Post(user: user, textPost: text, imagePost: image)
       allPosts.append(newPost)
       tableView.reloadData()
   }
    /// локальные посты из postfile
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
                let user = User(identifier: "annaux_designer", username: "Анна Мищенко", profilePicture: UIImage(named:"header1"), status: "дизайнер",gender: "Женский", birthday: "01.02.1997", city: "Москва",hobby: "футбол",school:"Дизайнер", university: "школа 134", work: "Московский")
                let post = Post(user: user, textPost: textPost, imagePost: imagePost)
                posts.append(post)
            }
        }
        print(posts)

        return posts
    }
    
}
// MARK: - PostTableViewCellLikeDelegate
extension ProfileViewController: PostTableViewCellLikeDelegate {
    func postTableViewCellDidTapLikeSaveWith(_ model: Post) {
        likedPosts.append(model)
        print(likedPosts)
    }
}
// MARK: - PostTableViewCellSaveDelegate
extension ProfileViewController: PostTableViewCellSaveDelegate {
    func postTableViewCellDidTapSavePostWith(_ model: Post) {
        savedPosts.append(model)
        print(savedPosts)
    }
}
