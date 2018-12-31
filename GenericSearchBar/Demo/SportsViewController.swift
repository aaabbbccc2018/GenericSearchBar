//
//  SportsViewController.swift
//  GenericSearchBar
//
//  Created by Nicolas Mulet on 31/12/2018.
//  Copyright © 2018 Nicolas Mulet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SportsViewController: SearchViewController<Sport> {
    private let tableView = UITableView()
    private let bag = DisposeBag()
    
    override var contentView: UIView {
        return tableView
    }
    
    override var loadingView: UIView {
        let view = UIView(frame: .zero)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }
    
    override var errorView: UIView {
        let view = UIView(frame: .zero)
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "An error occured ⚠️"
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }
    
    init() {
        super.init(viewModel: SportsViewModel())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(viewModel: SportsViewModel())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupObservers()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(UINib(nibName: "SportCell", bundle: nil), forCellReuseIdentifier: "SportCell")
    }
    
    func setupObservers() {
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
