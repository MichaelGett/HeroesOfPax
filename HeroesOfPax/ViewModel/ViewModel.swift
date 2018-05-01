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
    var didUpdateTemperature: PublishSubject<Temperature> { get }
    var didUpdatePressures: PublishSubject<[LegPressure]> { get }
    
    //Output
    var rightLegTempTitle: Driver<String> { get }
    var leftLegTempTitle: Driver<String> { get }
    var pressuersTitles: Driver<[(title: String, color: UIColor)]> { get }
}

