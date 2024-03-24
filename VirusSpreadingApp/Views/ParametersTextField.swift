//
//  ParametersTextField.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import UIKit

final class ParametersTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.leadingPadding(8)
        self.keyboardType = .numberPad
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 4
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
