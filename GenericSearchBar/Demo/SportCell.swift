//
//  SportCell.swift
//  GenericSearchBar
//
//  Created by Nicolas Mulet on 31/12/2018.
//  Copyright © 2018 Nicolas Mulet. All rights reserved.
//

import UIKit

class SportCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    
    func configure(name: String) {
        nameLabel.text = name
    }
}
