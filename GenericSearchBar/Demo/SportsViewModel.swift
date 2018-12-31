//
//  SportsViewModel.swift
//  GenericSearchBar
//
//  Created by Nicolas Mulet on 31/12/2018.
//  Copyright © 2018 Nicolas Mulet. All rights reserved.
//

import RxCocoa
import RxSwift

class SportsViewModel: SearchViewModel<Sport> {
    override func search(with keyword: String) -> Observable<[Sport]> {
        let sports = keyword.isEmpty ? [] : [Sport(name: "Football"),
                                             Sport(name: "Baseball"),
                                             Sport(name: "Basketball"),
                                             Sport(name: "Soccer"),
                                             Sport(name: "Hockey"),
                                             Sport(name: "Golf")]
        
        // Here we just return sports whose name start with the same letter than the keyword.
        let filteredSports = sports.filter { $0.name[$0.name.startIndex] == keyword[keyword.startIndex] }
        
        return Observable.create({ (observer) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if filteredSports.isEmpty {
                    observer.onError(SearchError.notFound)
                } else {
                    observer.onNext(filteredSports)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        })
    }
}
