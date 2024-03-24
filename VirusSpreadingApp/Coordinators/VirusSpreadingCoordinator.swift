//
//  VirusSpreadingCoordinator.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import UIKit

final class VirusSpreadingCoordinator: Coordinatable {
    let moduleType: Module.ModuleType
    
    private let factory: AppFactory
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = self.factory.makeModule(ofType: self.moduleType)
        let viewController = module.viewController
        (module.viewModel as? VirusSpreadingViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func popViewController() {
        guard let navController = module?.viewController as? UINavigationController else { return }
        navController.popViewController(animated: true)
    }
}
