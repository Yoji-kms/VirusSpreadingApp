//
//  VirusSpreadingViewModelProtocol.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import Foundation

protocol VirusSpreadingViewModelProtocol: ViewModelProtocol {
    var parameters: VirusParameters { get }
    var data: [Human] { get }
    var infected: Int { get }
    var healthy: Int { get }
    func handleViewInput(input: VirusSpreadingViewModel.ViewInput)
}
