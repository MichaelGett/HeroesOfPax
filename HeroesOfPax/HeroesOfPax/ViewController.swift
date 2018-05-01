//
//  ViewController.swift
//  HeroesOfPax
//
//  Created by Michael Hait on 30/04/2018.
//  Copyright © 2018 MakersForHeroes. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class ViewController: UIViewController {
    @IBOutlet var legPressuresLabels: [UIButton]!
    
    var viewModel: ViewModeling!
    
    private var topConstraint: [Int: Constraint] = [Int: Constraint]()

    
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bleService = BLEService()
        let service = Service(bleService: bleService)
        view.layoutIfNeeded()
        viewModel = ViewModel(service: service, viewsHeight: (legPressuresLabels.first?.frame.height)!)
        
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        legPressuresLabels.forEach { (button) in
            let view = UIView()
            print("VVVV: \(view)")
            view.backgroundColor = UIColor.red
            view.tag = 22
            button.addSubview(view)
            button.sendSubview(toBack: view)
            view.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(0)
                self.topConstraint[button.tag] = make.top.equalTo(button.frame.height).constraint
            }
        }
    }
    
    private func setupBindings() {
        
        viewModel
            .pressuersTitles
            .drive(onNext: { [weak self] titles in
                self?.legPressuresLabels.forEach { (button) in
                    let title = titles[button.tag]
                    button.setTitle(title, for: .normal)
                }
            }).disposed(by: disposeBag)
        
        viewModel
            .viewNormalizedHeight
            .drive(onNext: { [weak self] heights in
                self?.legPressuresLabels.forEach { (button) in
                    guard let view = button.viewWithTag(22) else { return }
                    
                    view.snp.updateConstraints { (make) in
                        self?.topConstraint[button.tag]?.update(offset: button.frame.height - heights[button.tag])
                    }
                    
                    UIView.animate(withDuration: 1, animations: {
                        self?.view.layoutIfNeeded()
                    })
                }
                
            }).disposed(by: disposeBag)
    }
}

