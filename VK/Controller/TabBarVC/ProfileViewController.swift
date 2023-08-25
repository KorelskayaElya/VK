//
//  ProfileViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit
import KeychainAccess


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
        headerView.nameLabel.text = user.username
        headerView.descriptionLabel.text = user.status
        headerView.delegate = self
        headerView.cameraDelegate = self
        headerView.editProfileDelegate = self
        headerView.addPhotoDelegate = self
        headerView.editProfileDelegate = self
        headerView.furtherInformation = self
        let profileViewModel = ProfileHeaderViewModel(user: User(identifier: "annaux_designer", username: "Анна Мищенко", profilePicture: UIImage(contentsOfFile: path!.path), status: "дизайнер",gender: "Женский", birthday: "01.02.1997", city: "Москва",hobby: "футбол",school:"Дизайнер", university: "школа 134", work: "Московский"), followerCount: 4, followingCount: 5, isFollowing: false, publishedPhotos: CoreDataService.shared.posts.count)
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
    /// делегат для выхода из аккаунта
    weak var delegate: ProfileViewControllerDelegate?
    /// открытие того или другого presentationcontroller
    var isOpenEdit = false
    var isOpenDetails = false
    lazy var path = documentDirectoryPath()?.appendingPathComponent("profileImage.jpg")
    
    var user: User
    /// для показа отфильрованных постов и всех постов
    var isFiltering: Bool = false
    var filteredPosts: [PostEntity] = []
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
    let headerView = ProfileTableHeaderView()

    
    
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
        menuIcon.tintColor = UIColor(named: "Orange")
        navigationItem.rightBarButtonItem = menuIcon
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        /// отображаются посты при создании
        tableView.reloadData()
        /// после выхода из камеры отобразить
        tabBarController?.tabBar.isHidden = false
    }
    /// появляется изображение после его смены
    override func viewDidAppear(_ animated: Bool) {
        let profileViewModel = ProfileHeaderViewModel(user: User(identifier: "annaux_designer", username: "Анна Мищенко", profilePicture: UIImage(contentsOfFile: path!.path) ?? UIImage(named: "header1"), status: "дизайнер",gender: "Женский", birthday: "01.02.1997", city: "Москва",hobby: "футбол",school:"Дизайнер", university: "школа 134", work: "Московский"), followerCount: 4, followingCount: 5, isFollowing: false, publishedPhotos: CoreDataService.shared.posts.count)
        headerView.configure(with: profileViewModel)
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
    
    // MARK: - Methods
    /// переход на фотографии
    func didTapButton(sender: UIButton) {
        let photosViewController = PhotosViewController()
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
        if searchText.isEmpty {
            isFiltering = false
            tableView.reloadData()
        } else {
            isFiltering = true
            filteredPosts = CoreDataService.shared.filterPostsBy(text: searchText)
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
            return isFiltering ? filteredPosts.count : CoreDataService.shared.posts.count
        }
    }
    /// шапка профиля
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
    
    /// отображение секций
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
            let post = isFiltering ? filteredPosts[indexPath.row] : CoreDataService.shared.posts[indexPath.row]
            cell.configure(with: post, textFont: UIFont(name: "Arial", size: 14)!, contentWidth: tableView.frame.width - 100)
            /// для лайка
            cell.delegate = self
            /// для сохранения поста
            cell.saveDelegate = self
            return cell
        }
    }
    /// высота поста
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 120
        } else if indexPath.section == 2 {
            return 60
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
            let post = isFiltering ? filteredPosts[indexPath.row] : CoreDataService.shared.posts[indexPath.row]

            let textFont = UIFont(name: "Arial", size: 14)!
            let contentWidth = tableView.frame.width - 100
            let textHeight = cell.calculateTextHeight(text: post.textPost ?? "", font: textFont, width: contentWidth)


            var image: UIImage?
            if let imageData = post.imagePost {
                image = UIImage(data: imageData)
            }

            let imageHeight = cell.calculateImageHeight(image: image, width: contentWidth)

            let timeHeight: CGFloat = 20
            let avatarHeight: CGFloat = 40
            let nameLabelHeight: CGFloat = 20
            let descriptionLabelHeight: CGFloat = 20
            let otherViewHeights: CGFloat = 90
            let totalHeight = textHeight + imageHeight + timeHeight + avatarHeight + nameLabelHeight + descriptionLabelHeight + otherViewHeights

            return totalHeight

        }
    }
    /// удаление постов
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 3 {
            if isFiltering {
                let post = filteredPosts[indexPath.row]
                CoreDataService.shared.deletePost(post: post)
                filteredPosts.remove(at: indexPath.row)
            } else {
                let post = CoreDataService.shared.posts[indexPath.row]
                CoreDataService.shared.deletePost(post: post)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    /// запрет на свайп удаления секций кроме постов
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 3
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
        navigationController?.pushViewController(saveVC, animated: true)
    }
}
extension ProfileViewController: ProfileCameraDelegate {
    /// включить камеру для истории
    func didTapCamera() {
        let vc = CameraViewController()
        vc.delegate = self
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ProfileViewController: ProfileAddPhotoDelegate {
    func didAddPhoto() {
        let photosViewController = PhotosViewController()
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
        navigationController?.pushViewController(vc, animated: true)
    }

    /// обновить таблицу после нового поста
    func postAddViewController(_ controller: PostAddViewController, didCreatePost post: Post) {
        // добавление поста сверху
        tableView.reloadData()
    }
}
// MARK: - PostTableViewCellLikeDelegate
extension ProfileViewController: PostTableViewCellLikeDelegate {
    /// лайкнуть пост
    func postTableViewCellDidTapLikeSaveWith(_ post: PostEntity) {
        post.isLikedByCurrentUser.toggle()
        CoreDataService.shared.saveContext()
        CoreDataService.shared.reloadPosts()
        tableView.reloadData()
    }
}
// MARK: - LikeViewControllerDelegate
extension ProfileViewController: LikeViewControllerDelegate {
    /// убрать из лайк постов лайк
    func likeViewControllerDidTapLikeSaveWith(_ post: PostEntity) {
        post.isLikedByCurrentUser.toggle()
        CoreDataService.shared.saveContext()
        CoreDataService.shared.reloadPosts()
        tableView.reloadData()
    }
}
// MARK: - PostTableViewCellSaveDelegate
extension ProfileViewController: PostTableViewCellSaveDelegate {
    /// добавить пост в закладки
    func postTableViewCellDidTapSavePostWith(_ post: PostEntity) {
        post.isSavedByCurrentUser.toggle()
        CoreDataService.shared.saveContext()
        CoreDataService.shared.reloadPosts()
        tableView.reloadData()
    }
}
// MARK: - SaveViewControllerDelegate
extension ProfileViewController: SaveViewControllerDelegate {
    /// убрать из закладок пост
    func saveViewControllerDidTapSaveWith(_ post: PostEntity) {
        post.isSavedByCurrentUser.toggle()
        CoreDataService.shared.saveContext()
        CoreDataService.shared.reloadPosts()
        tableView.reloadData()
    }
}
// MARK: - CameraPhotoSaveDelegate
extension ProfileViewController: CameraPhotoSaveDelegate {
    
    func cameraPhototSave(_ image: UIImage) {
        savePng(image)
        navigationController?.popViewController(animated: true)
    }
    
    func savePng(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let path = documentDirectoryPath()?.appendingPathComponent("profileImage.jpg")
            try? data.write(to: path!)
        }
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
}
