//
//  ViewController.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import UIKit

final class ParametersViewController: UIViewController {
//    MARK: Variables
    private let viewModel: ParametersViewModelProtocol
    
    private let leadingPadding: CGFloat = 8
    private let trailingPadding: CGFloat = -8
    private let spacing: CGFloat = 16
    private let textFieldHeight: CGFloat = 32
    
//    MARK: Views
    private lazy var groupSizeLabel: UILabel = {
        let text = NSLocalizedString(Strings.groupSize.rawValue, comment: Strings.groupSize.rawValue)
        let label = ParametersLabel(text: text)
        return label
    }()
    
    private lazy var groupSizeTextField: UITextField = {
        let textField = ParametersTextField(placeholder: "100")
        textField.addTarget(self, action: #selector(validateButton), for: .editingChanged)
        return textField
    }()
    
    private lazy var infectionFactorLabel: UILabel = {
        let text = NSLocalizedString(Strings.infectionFactor.rawValue, comment: Strings.infectionFactor.rawValue)
        let label = ParametersLabel(text: text)
        return label
    }()
    
    private lazy var infectionFactorTextField: UITextField = {
        let textField = ParametersTextField(placeholder: "3")
        textField.addTarget(self, action: #selector(validateButton), for: .editingChanged)
        return textField
    }()
    
    private lazy var periodLabel: UILabel = {
        let text = NSLocalizedString(Strings.period.rawValue, comment: Strings.period.rawValue)
        let label = ParametersLabel(text: text)
        return label
    }()
    
    private lazy var periodTextField: UITextField = {
        let textField = ParametersTextField(placeholder: "1")
        textField.addTarget(self, action: #selector(validateButton), for: .editingChanged)
        return textField
    }()
    
    private lazy var startModelingButton: UIButton = {
        let button = UIButton()
        let text = NSLocalizedString(Strings.startModeling.rawValue, comment: Strings.startModeling.rawValue)
        button.setTitle(text, for: .normal)
        button.isEnabledAndClear = false
        
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startModelingButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    MARK: Inits
    init(viewModel: ParametersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViews()
        self.setupGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    MARK: Setups
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setupViews() {
        self.view.addSubview(groupSizeLabel)
        self.view.addSubview(groupSizeTextField)
        self.view.addSubview(infectionFactorLabel)
        self.view.addSubview(infectionFactorTextField)
        self.view.addSubview(periodLabel)
        self.view.addSubview(periodTextField)
        self.view.addSubview(startModelingButton)
        
        NSLayoutConstraint.activate([
            groupSizeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            groupSizeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPadding),
            groupSizeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingPadding),
            
            groupSizeTextField.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor),
            groupSizeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPadding),
            groupSizeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingPadding),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: spacing),
            infectionFactorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPadding),
            infectionFactorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingPadding),
            
            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor),
            infectionFactorTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPadding),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingPadding),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            periodLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: spacing),
            periodLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPadding),
            periodLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingPadding),
            
            periodTextField.topAnchor.constraint(equalTo: periodLabel.bottomAnchor),
            periodTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPadding),
            periodTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingPadding),
            periodTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            startModelingButton.topAnchor.constraint(equalTo: periodTextField.bottomAnchor, constant: spacing),
            startModelingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPadding),
            startModelingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingPadding)
        ])
    }
    
//    MARK: Actions
    @objc func startModelingButtonDidTap() {
        let groupSize = Int(self.groupSizeTextField.text ?? "") ?? 0
        let infectionFactor = Int(self.infectionFactorTextField.text ?? "") ?? 0
        let period = Int(self.periodTextField.text ?? "") ?? 0
        
        let virusParameters = VirusParameters(groupSize: groupSize, infectionFactor: infectionFactor, period: period)
        self.viewModel.handleViewInput(.startModelingButtonDidTap(virusParameters))
    }
    
    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func validateButton() {
        self.groupSizeTextField.zeroCheck {
            self.viewModel.handleViewInput(.presentAlert)
        }
        self.infectionFactorTextField.zeroCheck {
            self.viewModel.handleViewInput(.presentAlert)
        }
        self.periodTextField.zeroCheck {
            self.viewModel.handleViewInput(.presentAlert)
        }
        
        let groupSizeEntered = self.groupSizeTextField.isNotEmpty
        let infectionFactorEntered = self.infectionFactorTextField.isNotEmpty
        let periodEntered = self.periodTextField.isNotEmpty
        
        let isEnabled = groupSizeEntered && infectionFactorEntered && periodEntered
        self.startModelingButton.isEnabledAndClear = isEnabled
    }
}
