//
//  BaseViewController.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        setUpSubviews()
        setUpNavigationBarAppearance()
    }
    
    func setUpNavigationBarAppearance() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundColor = .systemBackground
        
        let backImage = UIImage(systemName: "arrow.left")
        standardAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        navigationItem.standardAppearance = standardAppearance
        navigationItem.scrollEdgeAppearance = standardAppearance
        navigationItem.compactAppearance = standardAppearance
        if #available(iOS 15.0, *) {
            navigationItem.compactScrollEdgeAppearance = standardAppearance
        }
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonDisplayMode = .minimal
    }
}
