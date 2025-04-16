//
//  Alert.swift
//  iosTest
//
//  Created by Adrian Aguilar on 15/4/25.
//

import Foundation
import UIKit

func showAlert(vc: UIViewController, title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { (_) in }
    alertController.addAction(ok)
    vc.present(alertController, animated: true)
}
