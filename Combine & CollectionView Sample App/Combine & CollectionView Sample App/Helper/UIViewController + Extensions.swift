//
//  UIViewController + Extensions.swift
//  Combine & CollectionView Sample App
//
//  Created by Ali Bahadori on 14.01.21.
//

import UIKit

extension UIViewController{
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
