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
}
