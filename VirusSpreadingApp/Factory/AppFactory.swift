//
//  AppFactory.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import UIKit

final class AppFactory {
    func makeModule(ofType type: Module.ModuleType) -> Module {
        switch type {
        case .parameters:
            let viewModel = ParametersViewModel()
            let viewController: UIViewController = ParametersViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            return Module(type: .parameters, viewModel: viewModel, viewController: navController)
        case .virusSpreading(let parameters):
            let viewModel = VirusSpreadingViewModel(parameters: parameters)
            let viewController: UIViewController = VirusSpreadingModelViewController(viewModel: viewModel)
            return Module(type: .virusSpreading(parameters), viewModel: viewModel, viewController: viewController)
        }
    }
}
