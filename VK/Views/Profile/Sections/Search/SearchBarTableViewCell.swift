//
//  SearchBarTableViewCell.swift
//  VK
//
//  Created by Эля Корельская on 07.08.2023.
//
import UIKit

protocol SearchBarDelegate: AnyObject {
    func searchBarDidChange(_ searchText: String)
    func searchBarSearchButtonTapped()
}

// поисковая строка
class SearchBarTableViewCell: UITableViewCell, UISearchBarDelegate {
    // MARK: - Properties
    weak var searchBarDelegate: SearchBarDelegate?
    
    // MARK: - UI
    private var searchBar: UISearchBar!
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        searchBar.delegate = self
    }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        
        if searchBar.frame.contains(location) {
            return
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarDelegate?.searchBarDidChange(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarDelegate?.searchBarSearchButtonTapped()
    }
    
    func configure(with model: SearchBarModel) {
        searchBar.placeholder = model.placeholder
    }
}
