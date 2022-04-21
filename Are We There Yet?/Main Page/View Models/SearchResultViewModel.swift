//
//  SearchResultViewModel.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/6/22.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

class SearchResultViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Reactive properties
    var location: BehaviorRelay<Location> = BehaviorRelay(value: Location(title: "", coordinates: nil))
    var displayTitle: BehaviorRelay<String> = BehaviorRelay(value: "")

    init() {
        location
            .asObservable()
            .subscribe(onNext: { value in
                self.displayTitle.accept(value.title)
            })
            .disposed(by: disposeBag)
    }
}
