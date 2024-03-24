//
//  AlertUtils.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 24.03.2024.
//

import UIKit

final class AlertUtils {
    static func showUserMessage(_ message: String, context: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        context.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
    }
}
