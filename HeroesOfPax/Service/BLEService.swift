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
    var currentPressureValue: Observable<(Int,Float)> { get }
    var connectionStatus: Observable<BTStatus> { get }
    
}

class BLEService: NSObject, BLEServicing, BTConnectorDelegate {
    
    let start: PublishSubject<Void> = PublishSubject<Void>()
    let btconnector = BTConnector()

    let connectionStatusPublish: PublishSubject<BTStatus> = PublishSubject<BTStatus>()
    let currentPressureValuePublish: PublishSubject<(Int,Float)> = PublishSubject<(Int,Float)>()
    
    var currentPressureValue: Observable<(Int,Float)> {
        return currentPressureValuePublish.asObservable()
    }
    var connectionStatus: Observable<BTStatus> {
        return connectionStatusPublish.asObservable()
    }
    
    static let fakeData: [(Int, Float)] = [(0,12),(0,23),(0,60),
                                            (1,12),(1,23),(1,60),
                                            (2,12),(2,23),(2,60),
                                            (3,12),(3,23),(3,60),
                                            (4,12),(4,23),(4,60),
                                            (-1,-1)]
  
    private var disposeBag: DisposeBag = DisposeBag()
    override init() {
        
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
        if message == "pressure release" {
            currentPressureValuePublish.onNext((-1,-1))
        }
        let data = message.split(separator: ",")
        guard data.count == 2, let valve = Int(data[0]), let pressure = Float(data[1]) else {
            return
        }
        currentPressureValuePublish.onNext((valve,pressure))
    }

}
