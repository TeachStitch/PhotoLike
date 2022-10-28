//
//  UIViewController+Extensions.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import UIKit

// MARK: - Coordinator
extension UIViewController {
    private enum AssociatedObjectKey {
           static var coordinator = "UIViewControllerCoordinatorKey"
       }

    var coordinator: CoordinatorFacade? {
            get { return objc_getAssociatedObject(self, &AssociatedObjectKey.coordinator) as? CoordinatorFacade }
            set { objc_setAssociatedObject(self, &AssociatedObjectKey.coordinator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        }
}

// MARK: - Alerts
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
