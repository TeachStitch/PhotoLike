//
//  TabBarViewController.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    private let viewModel: TabBarViewModelProvider
    
    // MARK: - Initialization
    init(viewModel: TabBarViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onWillAppear()
    }
    
    private func setUpTabBar() {
        tabBar.tintColor = ColorName.gray02.color
        tabBar.unselectedItemTintColor = ColorName.gray01.color
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.shadowRadius = 12
        tabBar.layer.shadowColor = ColorName.gray03.color.cgColor
        tabBar.layer.shadowOpacity = 1
    }
}

// MARK: - TabBarViewModelDelegate
extension TabBarViewController: TabBarViewModelDelegate {
    func registerAdapters(_ adapters: [TabBarAdapterProvider]) {
        let rootViewControllers = adapters.map { $0.rootViewController }
        setViewControllers(rootViewControllers, animated: false)
    }
}
