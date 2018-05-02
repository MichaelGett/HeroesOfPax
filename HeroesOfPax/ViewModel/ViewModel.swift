//
//  ViewModel.swift
//  HeroesOfPax
//
//  Created by Gil Goldenberg on 30/04/2018.
//  Copyright © 2018 MakersForHeroes. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModeling {
    //Input
    var didTapStart: PublishSubject<Void> { get }
    
    var pressuersTitles: Driver<[String]> { get }
    var viewNormalizedHeight: Driver<([CGFloat], Int)> { get }
    var btStatus: Driver<String> { get }
}

class ViewModel: ViewModeling {
    var didTapStart: PublishSubject<Void> = PublishSubject<Void>()
    let pressuersTitles: Driver<[String]>
    let viewNormalizedHeight: Driver<([CGFloat], Int)>
    let btStatus: Driver<String>
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    init(service: Servicing, viewsHeight: CGFloat) {
        
        didTapStart
            .subscribe(onNext: { _ in
                service.start()
            }).disposed(by: disposeBag)
        
        pressuersTitles = service
            .didUpdatePressures
            .map { (pressures: [LegPressure]) -> [String] in
                pressures.map { (pressure: LegPressure) -> String in
                    "\(pressure.value)"
                }
            }.debug("RX: pressuersTitles")
            .asDriver(onErrorJustReturn: [])
        
        viewNormalizedHeight = service
            .didUpdatePressures
            .map { (pressures: [LegPressure]) -> ([CGFloat],Int) in
                let heights = pressures.map { (pressure: LegPressure) -> CGFloat in
                    calc(buttonHeight: viewsHeight, currentValue: pressure.value , maxValue: 150)
                }
                return (heights, pressures.first?.direction == .down ? 12 : 1)
            }.asDriver(onErrorJustReturn: ([],0))
        
        btStatus = service
            .didUpdateBTConnection
            .map{ (status) -> String in
                switch status {
                    case .connected:
                        return "Connected"
                    case .connecting:
                        return "Connecting"
                    case .disconnected:
                        return "Disconnected"
                    }
                }
        .asDriver(onErrorJustReturn: "Disconnected")
    }
}

private func calc(buttonHeight: CGFloat, currentValue: Float, maxValue: Float ) -> CGFloat {
    let height = Float(buttonHeight)
    return  CGFloat((height / maxValue) * currentValue)
}
