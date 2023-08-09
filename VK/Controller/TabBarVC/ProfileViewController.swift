//
//  ProfileViewController.swift
//  VK
//
//  Created by Эля Корельская on 22.07.2023.
//

import UIKit
import KeychainAccess

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ButtonDelegate {

    
    var user: User
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return createHeaderView()
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 390
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
            cell.configure(with: SearchBarModel(placeholder: "Мои записи"))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            cell.configure(with: UIImage(named: "picture\(indexPath.row+1)"))
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 120
        } else if indexPath.section == 2 {
            return 60
        } else {
            return 120
        }
    }

    func didTapButton(sender: UIButton) {
        let vc = PhotosViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
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


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let profileId = UILabel()
        profileId.text = user.identifier
        profileId.font = UIFont.boldSystemFont(ofSize: 17.0)
        profileId.textColor = UIColor.black
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileId)
        let outIcon = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(didOut))
        outIcon.tintColor = UIColor.black
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: profileId),outIcon]

        let menuIcon = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(openMenu))
        menuIcon.tintColor = UIColor(named: "Orange")
        navigationItem.rightBarButtonItem = menuIcon
        setupView()
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets.zero
    }

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
                        
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            let welcomeVC = WelcomeViewController()
                            let navVC = UINavigationController(rootViewController: welcomeVC)
                            navVC.modalPresentationStyle = .fullScreen
                            appDelegate.window?.rootViewController = navVC
                        }
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






    @objc func openMenu() {
        let halfScreenWidth = UIScreen.main.bounds.width * 3 / 4
        let halfScreenViewController = UIViewController()
        halfScreenViewController.view.backgroundColor = .white
        halfScreenViewController.modalPresentationStyle = .custom
        halfScreenViewController.transitioningDelegate = self
        halfScreenViewController.preferredContentSize = CGSize(width: halfScreenWidth, height: UIScreen.main.bounds.height)
        
        present(halfScreenViewController, animated: true, completion: nil)
    }

}
// не понятно как два presentation vc использвать в одном profile vc и как переходить из presentationvc в новый vc
extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        if presented is EditProfilePresentationViewController {
            return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting, user: user)
//        } else if presented is HalfScreenPresentationViewController {
//            return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting, user: user)
//        }
//        return nil
    }
}


