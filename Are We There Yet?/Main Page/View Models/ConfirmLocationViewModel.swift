//
//  ConfirmLocationViewModel.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/8/22.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

class ConfirmLocationViewModel {
    private let disposeBag = DisposeBag()
    
    var selectedLocation: BehaviorRelay<Location?> = BehaviorRelay(value: nil)
    var displayButtonText = "Confirm Location"
    var radius: BehaviorRelay<Int> = BehaviorRelay(value: 150)
    var sliderMinValue: Float { return 15 }
    var sliderMaxValue: Float { return 200 }
    
    init() {
        
    }
}

extension ConfirmLocationViewModel {
    @objc
    func didTapBackButton() {
        
    }
    @objc
    func didChangeSliderValue(_ sender: UISlider) {
        print(sender.value)
        radius.accept(Int(sender.value) * 10)
    }
}

