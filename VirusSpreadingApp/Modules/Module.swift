//
//  Module.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import UIKit

struct Module {
    enum ModuleType {
        case parameters
        case virusSpreading(VirusParameters)
    }
    
    let type: ModuleType
    let viewModel: ViewModelProtocol
    let viewController: UIViewController
}
