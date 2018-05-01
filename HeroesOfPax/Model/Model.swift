//
//  Model.swift
//  HeroesOfPax
//
//  Created by Gil Goldenberg on 30/04/2018.
//  Copyright © 2018 MakersForHeroes. All rights reserved.
//

import Foundation

struct Temperature {
    let rightLegTemp: Float
    let leftLegTemp: Float
}

struct LegPressure {
    let value: Float //Pressure probalby 0-150
}


struct LegState {
    let currentPumpIndex: Int
    let pressures: [LegPressure]
    
    func nextState(_ newPressure: Float) -> LegState {
        let currentPressure = pressures[currentPumpIndex]
        let newLegPressure = LegPressure(value: newPressure)
        var mutablePressures = pressures
        
        if currentPressure.value > newPressure { //Next pump
            let newIndex = (currentPumpIndex + 1) % pressures.count
            mutablePressures[newIndex] = newLegPressure
            
            return LegState(currentPumpIndex: newIndex , pressures: mutablePressures)
        } else {
            mutablePressures[currentPumpIndex] = newLegPressure
            
            return LegState(currentPumpIndex: currentPumpIndex , pressures: mutablePressures)
        }
    }
    
    static func initialState() -> LegState {
        let firstPressures: [LegPressure] = (0..<5).map { _ in LegPressure(value: 0.0) }
        
        return LegState(currentPumpIndex: 0, pressures: firstPressures)
    }
    
}

