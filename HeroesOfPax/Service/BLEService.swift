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
    // input
    var start: PublishSubject<Void> { get }
    
    //output
    var currentPressureValue: Observable<Float> { get }
}

class BLEService: BLEServicing {
    let start: PublishSubject<Void> = PublishSubject<Void>()
    
    let currentPressureValue: Observable<Float>
    
    static let fakeData: [Float] = [0, 30,60,90,120,30,60,90,120,30,60,90,120,30,60,90,120,30,60,90,120,-1]
  
    private var disposeBag: DisposeBag = DisposeBag()
    init() {
        
        currentPressureValue = start
            .flatMap { _ -> Observable<Int> in
                Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.instance)
            }
            .map { time -> Float in
                let index = time % BLEService.fakeData.count
                return BLEService.fakeData[index]
            }.debug("RX: currentPressureValue")
    }
}
