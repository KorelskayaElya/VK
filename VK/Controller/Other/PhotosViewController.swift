//
//  PhotosViewController.swift
//  VK
//
//  Created by Эля Корельская on 03.08.2023.
//

import UIKit


class PhotosViewController: UIViewController {
    // обновление информации
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

    // создаем пустой массив
    private var recivedImages: [UIImage] = []

    // Function to convert image file names to UIImage objects
    private func setupImages(from photoNames: [String]) {
        recivedImages = photoNames.compactMap { UIImage(named: $0) }
    }
    
    private lazy var flowLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.size.width - 40) / 3, height: (self.view.frame.size.width - 40) / 3)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return layout
    }()
    private lazy var collection: UICollectionView = {
        let myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        myCollectionView.backgroundColor = .black
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        myCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        return myCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBar()
        viewModel?.photoAdd()
    }
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.collection)
    
        NSLayoutConstraint.activate([
            self.collection.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Photo Gallery"
    
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

}
extension PhotosViewController: UICollectionViewDataSource,  UICollectionViewDelegate {
   
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
    
