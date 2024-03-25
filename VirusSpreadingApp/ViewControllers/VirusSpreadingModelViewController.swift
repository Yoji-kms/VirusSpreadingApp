//
//  VIrusSpreadingModelViewController.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import UIKit

final class VirusSpreadingModelViewController: UIViewController {
//    MARK: Variables
    private let viewModel: VirusSpreadingViewModelProtocol
    private var numberOfColumns: CGFloat = 0
    private let defaultNumberOfColumns: CGFloat
    
//    MARK: Views
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        let title = NSLocalizedString(Strings.virusSpreadingModel.rawValue, comment: Strings.virusSpreadingModel.rawValue)
        
        lbl.text = title
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var infectedLabel: ModelHeaderLabel = {
        let infected = viewModel.infected
        let infectedLocalizable = NSLocalizedString(Strings.infected.rawValue, comment: Strings.infected.rawValue)
        let infectedText = " \(infectedLocalizable): \(infected)"

        let label = ModelHeaderLabel(
            text: infectedText,
            color: .systemRed
        )
        return label
    }()
    
    private lazy var healthyLabel: ModelHeaderLabel = {
        let healthy = viewModel.healthy
        let healthyLocalizable = NSLocalizedString(Strings.healthy.rawValue, comment: Strings.healthy.rawValue)
        let healthyText = " \(healthyLocalizable): \(healthy)"

        let label = ModelHeaderLabel(
            text: healthyText,
            color: .systemGreen
        )
        return label
    }()
    
    private lazy var modelLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        let itemWidth = self.getItemSizeByColumnsNumber(self.defaultNumberOfColumns)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return layout
    }()
    
    private lazy var model: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: modelLayout)
        
        collectionView.register(ModelCollectionViewCell.self, forCellWithReuseIdentifier: "ModelCollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelectionDuringEditing = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
//    MARK: Actions
    @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = 1 / gesture.scale
            let scaledNumberOfColumns = scale * numberOfColumns
            switch scaledNumberOfColumns {
            case ..<1:
                numberOfColumns = 1
            case 1...self.defaultNumberOfColumns:
                numberOfColumns = scaledNumberOfColumns
            default:
                numberOfColumns = self.defaultNumberOfColumns
            }
            
            let scaledItemSize = self.getItemSizeByColumnsNumber(numberOfColumns)
            model.performBatchUpdates {
                modelLayout.itemSize = CGSize(width: scaledItemSize, height: scaledItemSize)
            }
        }
    }
    
//    MARK: Inits
    init(viewModel: VirusSpreadingViewModelProtocol) {
        self.viewModel = viewModel
        self.defaultNumberOfColumns = self.viewModel.parameters.groupSize.numberOfColumns.toCGFloat()
        self.numberOfColumns = self.defaultNumberOfColumns
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupView()
        self.setupGesture()
    }
    
//    MARK: Setups
    private func setupGesture() {
        let recognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        self.model.addGestureRecognizer(recognizer)
    }
    
    private func setupView() {
        self.view.addSubview(model)
        self.view.addSubview(infectedLabel)
        self.view.addSubview(healthyLabel)
        self.view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            healthyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            healthyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            healthyLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            healthyLabel.heightAnchor.constraint(equalToConstant: 30),
            
            infectedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infectedLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            infectedLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            infectedLabel.heightAnchor.constraint(equalToConstant: 30),
            
            model.topAnchor.constraint(equalTo: healthyLabel.bottomAnchor),
            model.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            model.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            model.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = self.titleLabel
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.style = .navigator
    }
    
//    MARK: Methods
    private func getItemSizeByColumnsNumber(_ columnsNumber: CGFloat) -> CGFloat {
        let screenWidth = self.view.frame.width
        let itemWidth = (screenWidth - 8 * (columnsNumber - 1)) / columnsNumber
        return itemWidth
    }
    
    private func updateHeaderText() {
        let infected = viewModel.infected
        let healthy = viewModel.healthy
        
        let infectedLocalizable = NSLocalizedString(Strings.infected.rawValue, comment: Strings.infected.rawValue)
        let healthyLocalizable = NSLocalizedString(Strings.healthy.rawValue, comment: Strings.healthy.rawValue)
        
        let infectedText = " \(infectedLocalizable): \(infected)"
        let healthyText = " \(healthyLocalizable): \(healthy)"
        
        self.infectedLabel.attributedTextWithImage(text: infectedText)
        self.healthyLabel.attributedTextWithImage(text: healthyText)
    }
}

//  MARK: Extensions
extension VirusSpreadingModelViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.handleViewInput(input: .humanDidTap(indexPath.row) { ids in
            var indexPaths = ids.map { IndexPath(row: $0, section: 0) }
            indexPaths.append(indexPath)
            DispatchQueue.main.async {
                self.model.reloadItems(at: indexPaths)
                self.updateHeaderText()
            }
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        self.setEditing(true, animated: true)
    }
}

extension VirusSpreadingModelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.parameters.groupSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelCollectionViewCell", for: indexPath) as? ModelCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.setup(with: self.viewModel.data[indexPath.row])
        
        return cell
    }
}
