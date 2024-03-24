//
//  ModelCollectionViewCell.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import UIKit

final class ModelCollectionViewCell: UICollectionViewCell {
    private lazy var humanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = UIImage(systemName: "figure.stand")
        imageView.tintColor = .green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.humanImageView.tintColor = .systemGreen
    }
    
    func setup(with human: Human) {
        self.humanImageView.tintColor = human.isInfected ? .systemRed : .systemGreen
    }
    
    private func setupView() {
        self.addSubview(humanImageView)
        
        NSLayoutConstraint.activate([
            self.humanImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.humanImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.humanImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.humanImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
