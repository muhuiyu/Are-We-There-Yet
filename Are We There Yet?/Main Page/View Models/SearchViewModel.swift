//
//  SearchViewModel.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/6/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

class SearchViewModel {
    private let disposeBag = DisposeBag()
    
    var title: String { return "Where to?" }
    var textFieldPlaceholder: String { return "Enter destination" }
    
    private let searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return searchSubject.asObserver()
    }
    
    private let contentSubject = PublishSubject<[Location]>()
    var content: Driver<[Location]> {
        return contentSubject
            .asDriver(onErrorJustReturn: [])
    }
    
    var selectLocation: BehaviorRelay<Location?> = BehaviorRelay(value: nil)
    
    init() {
        searchSubject
            .asObservable()
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] keyword -> Observable<[Location]> in
                return self.searchLocations(keyword)
            }
            .subscribe(onNext: { [unowned self] elements in
                self.contentSubject.onNext(elements)
            })
            .disposed(by: disposeBag)
    }
}
extension SearchViewModel {
    func searchLocations(_ keyword: String?) -> Observable<[Location]> {
        return Observable.create { observer in
            guard let text = keyword, !text.isEmpty else {
                return Disposables.create()
            }
            print(text)

            LocationManager.shared.findLocations(with: text) { value in
                print(value)
                observer.onNext(value)
            }

            return Disposables.create()
        }
    }
    func didSelectLocation(_ location: Location) {
        selectLocation.accept(location)
    }
    func didDeselectLocation(_ location: Location) {
        selectLocation.accept(nil)
    }
}
