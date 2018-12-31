//
//  SearchViewController.swift
//  GenericSearchBar
//
//  Created by Nicolas Mulet on 23/12/2018.
//  Copyright © 2018 Nicolas Mulet. All rights reserved.
//

import Cartography
import RxCocoa
import RxSwift
import UIKit

class SearchViewController<T>: UIViewController {
    let searchBar = UISearchBar()
    let viewModel: SearchViewModel<T>
    private let bag = DisposeBag()
    
    var contentView: UIView {
        fatalError("ContentView must be overriden.")
    }
    
    var loadingView: UIView? {
        return nil
    }

    var errorView: UIView? {
        return nil
    }
    
    init(viewModel: SearchViewModel<T>) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        bindViews()
        
        // Initial state
        errorView?.isHidden = true
        loadingView?.isHidden = true
        view.backgroundColor = .white
    }
    
    /// Configures the searchBar by layouting it to the top of the view.
    private func configureSearchBar() {
        searchBar.barStyle = .default
        
        view.addSubview(searchBar)
        
        constrain(view, searchBar) { (view, searchBar) in
            searchBar.top ==  view.top + 33.0
            searchBar.leading == view.leading
            searchBar.trailing == view.trailing
            searchBar.height == 44.0
        }
    }
    
    /// Binds each the views to its corresponding value in the viewModel.
    private func bindViews() {
        // searchBar binding.
        searchBar
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.searchObserver)
            .disposed(by: bag)
        
        // contentView binding.
        viewModel
            .isLoading
            .asDriver()
            .drive(contentView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.error
            .map { $0 != nil }
            .drive(contentView.rx.isHidden)
            .disposed(by: bag)
        
        // loadingView binding.
        if let loadingView = loadingView {
            viewModel.isLoading
                .map(!)
                .drive(loadingView.rx.isHidden)
                .disposed(by: bag)
            
            viewModel.error
                .map { $0 != nil }
                .drive(loadingView.rx.isHidden)
                .disposed(by: bag)
        }
        
        // errorView binding.
        if let errorView = errorView {
            viewModel.error
                .map { $0 == nil }
                .drive(errorView.rx.isHidden)
                .disposed(by: bag)
        }
    }
}
