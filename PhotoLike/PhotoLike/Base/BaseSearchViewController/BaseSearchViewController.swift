//
//  BaseSearchViewController.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

class BaseSearchViewController: BaseViewController {
    // MARK: - Properties
    var maxSearchTextLenght = 24
    var searchWorkItem: DispatchWorkItem?
    
    // MARK: - Method(s)
    override func loadView() {
        super.loadView()
        setUpSubviews()
        setUpSearchBar()
    }
    
    func setUpSearchBar() {
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    private func setUpSubviews() {
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - UISearchBarDelegate
extension BaseSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let invalidCharacters = CharacterSet.letters.union(.whitespacesAndNewlines).inverted
        guard text.rangeOfCharacter(from: invalidCharacters) == nil else { return false }

        guard let currentText = searchBar.text else { return false }
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        return updatedText.count <= maxSearchTextLenght
    }
}
