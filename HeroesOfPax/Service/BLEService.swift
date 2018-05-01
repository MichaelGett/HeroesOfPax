//
//  BLEService.swift
//  HeroesOfPax
//
//  Created by Gil Goldenberg on 01/05/2018.
//  Copyright © 2018 MakersForHeroes. All rights reserved.
//

import Foundation
import RxSwift

enum BTStatus {
    case connected
    case connecting
    case disconnected
    
}

protocol BLEServicing {
    // input
    var start: PublishSubject<Void> { get }
    
    //output
    var currentPressureValue: Observable<Float> { get }
    var connectionStatus: Observable<BTStatus> { get }
    
}

class BLEService: NSObject, BLEServicing, BTConnectorDelegate {
    
    let start: PublishSubject<Void> = PublishSubject<Void>()
    let btconnector = BTConnector()

    let connectionStatusPublish: PublishSubject<BTStatus> = PublishSubject<BTStatus>()
    let currentPressureValuePublush: PublishSubject<Float> = PublishSubject<Float>()
    
    var currentPressureValue: Observable<Float>  {
        return currentPressureValuePublush.asObservable()
    }
    var connectionStatus: Observable<BTStatus> {
        return connectionStatusPublish.asObservable()
    }
    
    static let fakeData: [Float] = [0, 30,60,90,120,30,60,90,120,30,60,90,120,30,60,90,120,30,60,90,120,-1]
  
    private var disposeBag: DisposeBag = DisposeBag()
    override init() {
        
//        currentPressureValue = start
//            .observeOn(MainScheduler.instance)
//            .flatMapLatest { _ -> Observable<Int> in
//                Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.instance)
//            }
//            .map { time -> Float in
//                let index = time % BLEService.fakeData.count
//                return BLEService.fakeData[index]
//            }.debug("RX: currentPressureValue")
        
        super.init()
        btconnector.delegate = self
        btconnector.startScan()
    }
    
    func connected() {
        connectionStatusPublish.onNext(.connected)
    }
    func disconnected() {
        connectionStatusPublish.onNext(.disconnected)
    }
    func scanning() {
        connectionStatusPublish.onNext(.connecting)
    }
    
    func receivedMessage(message: String) {
        guard let pressure = Float(message) else {
            return
        }
        currentPressureValuePublush.onNext(pressure)
    }

}
