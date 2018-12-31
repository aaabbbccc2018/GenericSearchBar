//
//  SportsViewController.swift
//  GenericSearchBar
//
//  Created by Nicolas Mulet on 31/12/2018.
//  Copyright © 2018 Nicolas Mulet. All rights reserved.
//

import Cartography
import RxCocoa
import RxSwift
import UIKit

class SportsViewController: SearchViewController<Sport> {
    private let tableView = UITableView()
    private let bag = DisposeBag()
    
    override var contentView: UIView {
        return tableView
    }
    
    private let _loadingView: UIView = {
        let view = UIView(frame: .zero)
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        constrain(activityIndicator) { activityIndicator in
            activityIndicator.edges == activityIndicator.superview!.edges
        }
        
        return view
    }()
    
    override var loadingView: UIView? {
        return _loadingView
    }
    
    private let _errorView: UIView = {
        let view = UIView(frame: .zero)
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "An error occured ⚠️"
        view.addSubview(label)
        
        constrain(label) { label in
            label.edges == label.superview!.edges
        }
        
        return view
    }()
    
    override var errorView: UIView? {
        return _errorView
    }
    
    init() {
        super.init(viewModel: SportsViewModel())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(viewModel: SportsViewModel())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupErrorView()
        setupTableView()
        setupObservers()
        setupLoadingView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        constrain(tableView, view, searchBar) { (view, superView, topView) in
            view.top == topView.bottom
            view.leading == superView.leading
            view.trailing == superView.trailing
            view.bottom == superView.bottom
        }
        
        tableView.register(UINib(nibName: "SportCell", bundle: nil), forCellReuseIdentifier: "SportCell")
    }
    
    private func setupLoadingView() {
        view.addSubview(_loadingView)
        
        constrain(tableView, _loadingView) { (tableView, view) in
            view.edges == tableView.edges
        }
    }
    
    private func setupErrorView() {
        view.addSubview(_errorView)
        
        constrain(_errorView, view, searchBar) { (view, superView, topView) in
            view.top == topView.bottom
            view.leading == superView.leading
            view.trailing == superView.trailing
            view.bottom == superView.bottom
        }
    }
    
    private func setupObservers() {
        guard let viewModel = viewModel as? SportsViewModel else {
            fatalError("Wrong viewModel type")
        }

        viewModel.content
            .drive(tableView.rx.items(cellIdentifier: "SportCell", cellType: SportCell.self)) { (index, sport: Sport, cell) in
                cell.configure(name: sport.name)
            }
            .disposed(by: bag)
    }
}
