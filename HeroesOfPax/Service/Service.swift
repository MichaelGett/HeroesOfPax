//
//  Service.swift
//  HeroesOfPax
//
//  Created by Gil Goldenberg on 30/04/2018.
//  Copyright © 2018 MakersForHeroes. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol Servicing {
    // Input
    var currentPressureValue: PublishSubject<Float> { get }
    var currentTemperatureValue: PublishSubject<[Float]> { get }   // 2 legs
    
    // Output
    var didUpdateTemperature: Observable<Temperature> { get }
    var didUpdatePressures: Observable<[LegPressure]> { get }
}

class Service: Servicing {
    // Input
    let currentPressureValue = PublishSubject<Float>()
    let currentTemperatureValue = PublishSubject<[Float]>()
    
    
    // Output
    let didUpdatePressures: Observable<[LegPressure]>
    let didUpdateTemperature: Observable<Temperature>
    
    
    // private
    var currentState: LegState
    
    init() {
        didUpdateTemperature = currentTemperatureValue
            .map { temp -> Temperature in
            Temperature(rightLegTemp: temp[0], leftLegTemp: temp[1])
        }
        
        didUpdatePressures = currentPressureValue.map { [weak self] presures -> [LegPressure] in
            [LegPressure(value: 41)]
//            self?.currentState.currentIndex
            
        }
    }
}
