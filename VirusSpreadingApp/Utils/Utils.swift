//
//  Utils.swift
//  VirusSpreadingApp
//
//  Created by Yoji on 22.03.2024.
//

import UIKit

extension Int {
    var numberOfColumns: Int {
        let double = Double(self)
        let sqrt = sqrt(double)
        let result = sqrt.rounded(.up)
        return Int(result)
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension Coordinates {
    func randomNearCoordinates(infectionFactor: Int, groupSize: Int) -> [Coordinates] {
        let coordinatesCount = Int.random(in: 0...infectionFactor)
        var returningCoordinates: [Coordinates] = []

        
        if coordinatesCount > 0 {
            for _ in 1...coordinatesCount {
                returningCoordinates.append(randomCoordinates(groupSize: groupSize))
            }
        }
        
        return returningCoordinates
    }
    
    private func randomCoordinates(groupSize: Int) -> Coordinates {
        var numberOfColumns = groupSize.numberOfColumns
        let numberOfRows = (groupSize % numberOfColumns == 0)
        ? groupSize / numberOfColumns
        : groupSize / numberOfColumns + 1
        let numberOfColumnsInLastRow = groupSize - (numberOfRows-1) * numberOfColumns
        
        let limitOfRows = self.row == numberOfRows-2 && self.column > numberOfColumnsInLastRow ? numberOfRows-1 : numberOfRows
        let resultRow: Int = randomNearCoordinate(currentCoordinate: self.row, numberOfCoordinates: limitOfRows)
        
        numberOfColumns = resultRow == numberOfRows-1 ? numberOfColumnsInLastRow : numberOfColumns
        let resultColumn: Int = randomNearCoordinate(currentCoordinate: self.column, numberOfCoordinates: numberOfColumns)
        
        return Coordinates(row: resultRow, column: resultColumn)
    }
    
    private func randomNearCoordinate(currentCoordinate: Int, numberOfCoordinates: Int) -> Int {
        let lastCoordinate = numberOfCoordinates - 1
        var result: Int = 0
        
        switch currentCoordinate {
        case 0:
            result = currentCoordinate == lastCoordinate ? 0 : Int.random(in: 0...1)
        case 1..<lastCoordinate:
            result = Int.random(in: currentCoordinate-1...currentCoordinate+1)
        case lastCoordinate:
            result = Int.random(in: lastCoordinate-1...lastCoordinate)
        case lastCoordinate + 1:
            result = lastCoordinate
        default:
            print("Default")
        }
        return result
    }
    
    func toId(numberOfColumns: Int) -> Int {
        return self.row * numberOfColumns + self.column
    }
}

extension UITextField {
    func leadingPadding(_ padding: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 0))
        self.leftViewMode = .always
    }

    var isNotEmpty: Bool {
        return !((self.text?.isEmpty ?? true) && self.text == "")
    }
    
    func zeroCheck(completion: @escaping () -> Void) {
        if self.text == "0" {
            self.text = ""
            completion()
        }
    }
}

extension UIButton {
    var isEnabledAndClear: Bool {
        get {
            return self.isEnabled
        }
        set(newValue) {
            self.isEnabled = newValue
            self.backgroundColor = isEnabled ? .systemBlue : .systemBlue.disabled
        }
    }
}

extension UIColor {
    var disabled: UIColor? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor (
                hue: hue, saturation: min(saturation - 0.6, 1.0), brightness: brightness, alpha: alpha
            )
        } else {
            return nil
        }
    }
}
