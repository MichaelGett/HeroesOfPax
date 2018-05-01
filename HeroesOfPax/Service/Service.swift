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
    // Output
    var didUpdateTemperature: Observable<Temperature> { get }
    var didUpdatePressures: Observable<[LegPressure]> { get }
}

class Service: Servicing {

    // Output
    let didUpdatePressures: Observable<[LegPressure]>
    let didUpdateTemperature: Observable<Temperature>
    
    
    // private
    private let state: Observable<LegState>
    
    init(bleService: BLEServicing) {
        let _state: Variable<LegState> = Variable<LegState>(LegState.initialState())
        
        state = bleService
            .currentPressureValue
            .withLatestFrom(_state.asObservable()) {(currentPressure, legState) -> LegState in
                 legState.nextState(currentPressure)
            }
            .do(onNext: { s in
                _state.value = s
            })
            .startWith(LegState.initialState())
            .debug("RX: State")

        didUpdatePressures = state
            .map { legState -> [LegPressure] in
                return legState.pressures
            }.debug("RX: didUpdatePressures")
        
        //TODO:
        didUpdateTemperature = Observable.just(Temperature(rightLegTemp: 0, leftLegTemp: 0))
    }
}
