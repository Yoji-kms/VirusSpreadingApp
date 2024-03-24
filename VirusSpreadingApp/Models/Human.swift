//
//  Human.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 21.03.2024.
//

import Foundation

struct Human {
    let id: Int
    var isInfected = false
    var coordinates: Coordinates?
    
    init(id: Int, isInfected: Bool = false, elementsCount: Int) {
        self.id = id
        self.isInfected = isInfected
        let numberOfColumns = elementsCount.numberOfColumns
        self.coordinates = self.getCoordinatesByColumnsNumber(numberOfColumns)
    }
    
    private func getCoordinatesByColumnsNumber(_ columnsNumber: Int) -> Coordinates {
        let row = self.id / columnsNumber
        let column = self.id % columnsNumber
        return Coordinates(row: row, column: column)
    }
}
