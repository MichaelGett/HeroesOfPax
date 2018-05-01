//
//  FillableButton.swift
//  HeroesOfPax
//
//  Created by Gil Goldenberg on 01/05/2018.
//  Copyright © 2018 MakersForHeroes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol FillableButtonViewModeling {
    // output
    var fillerHeightConstant: Driver<Int> { get }
    var title: Driver<String> { get }
}

//class FillableButtonViewModel: FillableButtonViewModeling {
//    let fillerHeightConstant: Driver<Int>
//    let title: Driver<String>
//    
//    init(service: Servicing, index: Int) {
////        fillerHeightConstant = service.didUpdatePressures.map { pressures -> Int in
////
////        }
//        
//    }
//}

class FillableButton: UIView {
    
}



