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
    var didUpdatePressures: Observable<[LegPressure]> { get }
    var didUpdateBTConnection: Observable<BTStatus> { get }
    
    func start() -> Void
}

class Service: Servicing {
    // Output
    let didUpdatePressures: Observable<[LegPressure]>
    let didUpdateBTConnection: Observable<BTStatus>
    
    // private
    private let state: Observable<LegState>
    private let bleService: BLEServicing
    private var disposeBag: DisposeBag = DisposeBag()
    
    init(bleService: BLEServicing) {
        self.bleService = bleService
        
        let _state: Variable<LegState> = Variable<LegState>(LegState.initialState())
        
        state = bleService
            .currentPressureValue
            .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .filter { $0.count > 0 }
            .map { (dataPoint) -> (Int, Float) in
                if dataPoint.contains(where: { (a) -> Bool in
                    if a.0 == -1 && a.1 == -1 { return true }
                    else { return false }
                }) {
                    return (-1,-1)
                } else {
                    let sorted = dataPoint.sorted(by: { (a, b) -> Bool in
                        if a.0 == b.0 {
                            return a.1 > b.1
                        } else {
                            return a.0 > b.0
                        }
                    })
                    return sorted.first!
                }
            }
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
        
        didUpdateBTConnection = bleService.connectionStatus
    }
    
    func start() {
        self.bleService.start.onNext(())
    }
}
