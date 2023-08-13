//
//  PhotosViewController.swift
//  VK
//
//  Created by Эля Корельская on 03.08.2023.
//

import UIKit

class PhotosViewController: UIViewController, ProfileAddPhotoViewControllerDelegate {

    func profileAddPhotoViewController(_ selectedImage: UIImage) {
        print("photos select image", selectedImage)
        recivedImages.append(selectedImage)
        print("count images", recivedImages.count)
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
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
    private func setupImages(from photoNames: [String]) {
        recivedImages = photoNames.compactMap { UIImage(named: $0) }
    }

    
    private var recivedImages: [UIImage] = []
    
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
    
//    private lazy var headerLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Comic Sans MS", size: 18)
//        label.text = "Альбомы  \(viewModel?.photoArr.count ?? 0)"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let lineView1 = LineView()
//    let lineView2 = LineView()

    
    private lazy var allPhotosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Comic Sans MS-Bold", size: 18)
        label.text = "Все фотографии  \(viewModel?.photoArr.count ?? 0)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        viewModel?.photoAdd()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
//        view.addSubview(headerLabel)
//        view.addSubview(lineView2)
//        view.addSubview(lineView1)
        view.addSubview(allPhotosLabel)
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            
//            lineView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            lineView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            lineView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            headerLabel.topAnchor.constraint(equalTo: lineView1.topAnchor, constant: 10),
//            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
//            headerLabel.widthAnchor.constraint(equalToConstant: 200),
//            headerLabel.heightAnchor.constraint(equalToConstant: 20),
//
//            lineView2.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 100),
//            lineView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            lineView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
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
        let addIcon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addPhoto))
        addIcon.tintColor = UIColor(named: "Orange")
        navigationItem.rightBarButtonItem = addIcon
        navigationItem.title = "Фотографии"
    }
    @objc func addPhoto() {
        print("add")
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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

    
