//
//  ParametersViewModel.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import Foundation

final class ParametersViewModel: ParametersViewModelProtocol {
    var coordinator: ParametersCoordinator?
    
    enum ViewInput {
        case startModelingButtonDidTap(VirusParameters)
        case presentAlert
    }
    
    func handleViewInput(_ viewInput: ViewInput) {
        switch viewInput {
        case .startModelingButtonDidTap(let parameters):
            coordinator?.pushVirusSpreadingViewController(parameters: parameters)
        case.presentAlert:
            coordinator?.presentAlert()
        }
    }
}
