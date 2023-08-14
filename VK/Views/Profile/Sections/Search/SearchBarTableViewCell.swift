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
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(searchBar)
        searchBar.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        contentView.addGestureRecognizer(tapGesture)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - Private
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
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    func configure(with model: SearchBarModel) {
        searchBar.placeholder = model.placeholder
    }
}
