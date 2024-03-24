//
//  VirusSpreadingViewModel.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import Foundation

final class VirusSpreadingViewModel: VirusSpreadingViewModelProtocol {
    weak var coordinator: VirusSpreadingCoordinator?
    let parameters: VirusParameters
    var data: [Human] = []
    var infected: Int {
        self.data.filter { $0.isInfected }.count
    }
    var healthy: Int {
        self.parameters.groupSize - self.infected
    }
    var isTimerStarted = false
    
    init(parameters: VirusParameters) {
        self.parameters = parameters
        for index in 1...parameters.groupSize {
            self.data.append(Human(id: index - 1, elementsCount: parameters.groupSize))
        }
    }
    
    enum ViewInput {
        case humanDidTap(Int, ([Int]) -> Void)
    }
    
    func handleViewInput(input: ViewInput) {
        switch input {
        case .humanDidTap(let index, let completion):
            Task(priority: .background) { [weak self] in
                guard let self else { return }
                self.data[index].infect {
                    completion([index])
                }
                
                if !isTimerStarted {
                    isTimerStarted = true
                    await self.timer(period: self.parameters.period) { result in
                        switch result {
                        case .success(let ids):
                            if !ids.isEmpty { completion(ids) }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    private func newInfectionState() async -> [Int] {
        var result: [Int] = []
        self.data.forEach { [weak self] human in
            guard let self else { return }
            if human.isInfected {
                let peopleToInfectIds = human
                    .coordinates?
                    .randomNearCoordinates(
                        infectionFactor: parameters.infectionFactor,
                        groupSize: parameters.groupSize
                    )
                    .map { $0.toId(numberOfColumns: self.parameters.groupSize.numberOfColumns) }
                peopleToInfectIds?.forEach { id in
                    self.data[id].infect {
                        result.append(id)
                    }
                }
            }
        }
        return result
    }
    
    private func timer(period: Int, completion: @escaping (Result<[Int], Error>)->Void) async {
        while (self.infected != self.parameters.groupSize) {
            do {
                try await Task.sleep(for: .seconds(period))
            } catch {
                completion(.failure(error))
            }
            
            let result = await self.newInfectionState()
            completion(.success(result))
        }
    }
}

extension Human {
    mutating func infect(completion: @escaping () -> Void) {
        if !self.isInfected {
            self.isInfected = true
            completion()
        }
    }
}
