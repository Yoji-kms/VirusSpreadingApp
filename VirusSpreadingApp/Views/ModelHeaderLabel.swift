//
//  ModelHeaderLabel.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 23.03.2024.
//

import UIKit

final class ModelHeaderLabel: UILabel {
    init(text: String, color: UIColor) {
        super.init(frame: .zero)
        
        self.attributedTextWithImage(text: text)
        self.textColor = color
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UILabel {
    func attributedTextWithImage(text: String) {
        let attributedText = NSMutableAttributedString()
        let image = UIImage(systemName: "figure.stand") ?? UIImage()
        let attachment = NSTextAttachment(image: image)
        
        attributedText.append(NSAttributedString(attachment: attachment))
        attributedText.append(NSAttributedString(string: text))
        
        self.attributedText = attributedText
    }
}
