//
//  PhotosViewController.swift
//  VK
//
//  Created by Эля Корельская on 03.08.2023.
//

import UIKit

@available(iOS 13.0, *)
class PhotosViewController: UIViewController, ProfileAddPhotoViewControllerDelegate {

    // MARK: - UI
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.size.width-15) / 2, height: (self.view.frame.size.width-15) / 2)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()

    
    private lazy var collection: UICollectionView = {
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        myCollectionView.backgroundColor = .systemBackground
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        return myCollectionView
    }()
    
    // MARK: - properties
    private var recivedImages: [UIImage] = []
    var viewModel: PhotoViewModel! {
        didSet {
            self.viewModel.photoChange = { [weak self] viewModel in
                if let photoNames = viewModel.photoNames {
                    self?.setupImages(from: photoNames)
                } else {
                    self?.recivedImages = []
                }
                self?.collection.reloadData()
            }
        }
    }

    private lazy var allPhotosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Comic Sans MS-Bold", size: 18)
        label.text = "Все фотографии  \(viewModel?.photoArr.count ?? 0)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        viewModel?.photoAdd()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(allPhotosLabel)
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            allPhotosLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            allPhotosLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            allPhotosLabel.widthAnchor.constraint(equalToConstant: 200),
            allPhotosLabel.heightAnchor.constraint(equalToConstant: 20),
            
            collection.topAnchor.constraint(equalTo: allPhotosLabel.bottomAnchor, constant: 10),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collection.heightAnchor.constraint(equalToConstant: 400),
        ])
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        let addIcon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addPhoto))
//        addIcon.tintColor = UIColor(named: "Orange")
//        navigationItem.rightBarButtonItem = addIcon
        navigationItem.title = "Фотографии"
    }
//    @objc func addPhoto() {
//        print("add")
//    }
    
    // MARK: - Private
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    private func setupImages(from photoNames: [String]) {
        recivedImages = photoNames.compactMap { UIImage(named: $0) }
    }
    func profileAddPhotoViewController(_ selectedImage: UIImage) {
        print("photos select image", selectedImage)
        recivedImages.append(selectedImage)
        print("count images", recivedImages.count)
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recivedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else {
            let mycell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return mycell
        }
        let imageName = recivedImages[indexPath.row]
        myCell.setupCell(with: imageName)
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}

    
