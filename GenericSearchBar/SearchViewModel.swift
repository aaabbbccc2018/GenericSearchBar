//
//  SearchViewModel.swift
//  GenericSearchBar
//
//  Created by Nicolas Mulet on 23/12/2018.
//  Copyright © 2018 Nicolas Mulet. All rights reserved.
//

import RxCocoa
import RxSwift

enum SearchError: Error {
    case underlyingError(Error)
    case notFound
    case unkowned
}

class SearchViewModel<T> {
    private let bag = DisposeBag()
    
    // MARK: - Search input
    private let searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return searchSubject.asObserver()
    }
    
    // MARK: - Search output
    private let contentSubject = PublishSubject<[T]>()
    var content: Driver<[T]> {
        return contentSubject.asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Loading output
    private let loadingSubject = PublishSubject<Bool>()
    var isLoading: Driver<Bool> {
        return loadingSubject.asDriver(onErrorJustReturn: false)
    }
    
    // MARK: - Error output
    private let errorSubject = PublishSubject<SearchError?>()
    var error: Driver<SearchError?> {
        return errorSubject.asDriver(onErrorJustReturn: .unkowned)
    }
    
    init() {
        searchSubject
            .asObservable()
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] term -> Observable<[T]> in
                // On every call to search, the error signal is set to nil to hide the error view.
                self.errorSubject.onNext(nil)
                
                // Switch to loading mode.
                self.loadingSubject.onNext(true)
                
                return self.search(with: term).catchError { [unowned self] error -> Observable<[T]> in
                    self.errorSubject.onNext(.underlyingError(error))
                    return .empty()
                }
            }
            .subscribe(onNext: { [unowned self] elements in
                self.loadingSubject.onNext(false)
                
                elements.isEmpty ? self.errorSubject.onNext(.notFound) : self.contentSubject.onNext(elements)
            })
            .disposed(by: bag)
    }
    
    func search(with keyword: String) -> Observable<[T]> {
        fatalError("This function must be overridden by your implementation.")
    }
}
