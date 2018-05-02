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

enum Direction {
    case up
    case down
}


struct LegPressure {
    let value: Float //Pressure probalby 0-150
    let direction: Direction
    
}


struct LegState {
    let currentPumpIndex: Int
    let pressures: [LegPressure]
    
    func nextState(_ newPressure: (Int,Float)) -> LegState {
        guard newPressure.1 != -1 else {
            //End of cycle - pressure reduced for all - back to initial state
            return LegState.initialState()
        }
        var mutablePressures = pressures
        let newLegPressure = LegPressure(value: newPressure.1, direction: .up)
        
        mutablePressures[newPressure.0] = newLegPressure
        return LegState(currentPumpIndex: newPressure.0 , pressures: mutablePressures)
    }
    
    static func initialState() -> LegState {
        let firstPressures: [LegPressure] = (0..<5).map { _ in LegPressure(value: 0.0, direction: .down) }
        return LegState(currentPumpIndex: 0, pressures: firstPressures)
    }
    
}

