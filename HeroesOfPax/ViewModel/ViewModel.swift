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
    //TODO: Phase 2
//    var didUpdatePressures: PublishSubject<[LegPressure]> { get }
    
    //Output
//    var rightLegTempTitle: Driver<String> { get }
//    var leftLegTempTitle: Driver<String> { get }
    var pressuersTitles: Driver<[String]> { get }
    var viewNormalizedHeight: Driver<[CGFloat]> { get }
}

class ViewModel: ViewModeling {
    let pressuersTitles: Driver<[String]>
    let viewNormalizedHeight: Driver<[CGFloat]>
    
    init(service: Servicing, viewsHeight: CGFloat) {
        pressuersTitles = service
            .didUpdatePressures
            .map { (pressures: [LegPressure]) -> [String] in
                pressures.map { (pressure: LegPressure) -> String in
                    "\(pressure.value)"
                }
            }.debug("RX: pressuersTitles").asDriver(onErrorJustReturn: [])
        
        viewNormalizedHeight = service
            .didUpdatePressures
            .map { (pressures: [LegPressure]) -> [CGFloat] in
                return pressures.map { (pressure: LegPressure) -> CGFloat in
                    calc(buttonHeight: viewsHeight, currentValue: pressure.value , maxValue: 150)
                }
            }.asDriver(onErrorJustReturn: [])
    }
}

private func calc(buttonHeight: CGFloat, currentValue: Float, maxValue: Float ) -> CGFloat {
    let height = Float(buttonHeight)
    return  CGFloat((height / maxValue) * currentValue)
}


