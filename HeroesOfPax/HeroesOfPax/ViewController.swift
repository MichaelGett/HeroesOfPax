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

    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bleService = BLEService()
        let service = Service(bleService: bleService)
        viewModel = ViewModel(service: service, viewsHeight: (legPressuresLabels.first?.frame.height)!)
        
        setupViews()
        setupBindings()
    }
    
    func setupViews() {
        legPressuresLabels.forEach { (button) in
            let view = UIView()
            print("VVVV: \(view)")
            view.backgroundColor = UIColor.red
            view.tag = 22
            button.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.edges.edges.equalTo(UIEdgeInsets(top: button.frame.height, left: 0, bottom: 0, right: 0))
            })
        }
    }
    
    func setupBindings() {
        
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
                    
                    if let view = button.viewWithTag(22) {
                        view.snp.remakeConstraints { (make) in
                            var edgeInsetes = UIEdgeInsets.zero
                            edgeInsetes.top = button.frame.height - heights[button.tag]
                            make.edges.equalTo(edgeInsetes)
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
}

