//
//  ParametersCoordinator.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import UIKit

final class ParametersCoordinator: Coordinatable {
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
        (module.viewModel as? ParametersViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinatable) {
        self.childCoordinators.removeAll(where: { $0 === coordinator })
    }
    
    func pushVirusSpreadingViewController(parameters: VirusParameters) {
        var childCoordinator: Coordinatable

        childCoordinator = VirusSpreadingCoordinator(moduleType: .virusSpreading(parameters), factory: self.factory)
        
        self.addChildCoordinator(childCoordinator)
        
        let viewControllerToPush = childCoordinator.start()
        guard let navController = module?.viewController as? UINavigationController else { return }
        navController.pushViewController(viewControllerToPush, animated: true)
    }
    
    func presentAlert() {
        guard let context = self.module?.viewController else { return }
        let message = NSLocalizedString(Strings.zeroAlertMessage.rawValue, comment: Strings.zeroAlertMessage.rawValue)
        
        AlertUtils.showUserMessage(message, context: context)
    }
}
