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
class SearchBarTableViewCell: UITableViewCell, UISearchBarDelegate {

    weak var searchBarDelegate: SearchBarDelegate?

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

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

    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        if searchBar.frame.contains(location) {
            // Tapped inside the search bar, do nothing
            return
        }
        // Tapped outside the search bar, dismiss the keyboard
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarDelegate?.searchBarDidChange(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarDelegate?.searchBarSearchButtonTapped()
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with model: SearchBarModel) {
        searchBar.placeholder = model.placeholder
    }
}
