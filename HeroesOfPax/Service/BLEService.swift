//
//  BLEService.swift
//  HeroesOfPax
//
//  Created by Gil Goldenberg on 01/05/2018.
//  Copyright © 2018 MakersForHeroes. All rights reserved.
//

import Foundation
import RxSwift



protocol BLEServicing {
    //output
    var currentPressureValue: Observable<Float> { get }
}


class BLEService: BLEServicing {
    
    let currentPressureValue: Observable<Float>
    static let fakeData: [Float] = [0.0,20.0,30.0,10.0,15.0,20,30,40,70,100,140,0,10,50]
    
    init() {
        currentPressureValue = Observable<Int>
            .timer(0, period: 1, scheduler: MainScheduler.instance)
            .map { time -> Float in
            let index = time % BLEService.fakeData.count
            return BLEService.fakeData[index]
            }.debug("RX: currentPressureValue")
    }
}
