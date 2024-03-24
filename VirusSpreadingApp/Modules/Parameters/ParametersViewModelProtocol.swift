//
//  ParametersViewModelProtocol.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import Foundation

protocol ParametersViewModelProtocol: ViewModelProtocol {
    func handleViewInput(_ viewInput: ParametersViewModel.ViewInput)
}
