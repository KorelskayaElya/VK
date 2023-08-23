//
//  PhotosViewController.swift
//  VK
//
//  Created by Эля Корельская on 03.08.2023.
//

import UIKit

class PhotosViewController: UIViewController {

    // MARK: - UI
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.size.width-60) / 2, height: (self.view.frame.size.width-60) / 2)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
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
   // private var recivedImages: [UIImage] = []

    private lazy var allPhotosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Comic Sans MS-Bold", size: 18)
        label.text = "All fotos".localized
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var countPhotosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Comic Sans MS-Bold", size: 18)
        label.textColor = .lightGray
        label.text = "\(CoreDataService.shared.photos.count ?? 0)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Private
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(allPhotosLabel)
        view.addSubview(collection)
        view.addSubview(countPhotosLabel)
        
        NSLayoutConstraint.activate([
            allPhotosLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            allPhotosLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            allPhotosLabel.widthAnchor.constraint(equalToConstant: 150),
            allPhotosLabel.heightAnchor.constraint(equalToConstant: 20),
            
            countPhotosLabel.leadingAnchor.constraint(equalTo: allPhotosLabel.trailingAnchor, constant: 5),
            countPhotosLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            countPhotosLabel.widthAnchor.constraint(equalToConstant: 100),
            countPhotosLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            collection.topAnchor.constraint(equalTo: allPhotosLabel.bottomAnchor, constant: 10),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.tintColor = UIColor(named: "Orange")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "Photos".localized
        let addPhotoButton = UIButton(type: .system)
        addPhotoButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addPhotoButton.tintColor = UIColor(named: "Orange")
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addPhotoButton)
                
    }
    

    @objc private func addPhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    private func updateCountPhotosLabel() {
        countPhotosLabel.text = "\(CoreDataService.shared.photos.count)"
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreDataService.shared.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else {
            let mycell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return mycell
        }
        let photoEntity = CoreDataService.shared.photos[indexPath.row]
        myCell.setupCell(with: photoEntity)
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            CoreDataService.shared.addPhoto(image: selectedImage.pngData())
            updateCountPhotosLabel()
            collection.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

    
