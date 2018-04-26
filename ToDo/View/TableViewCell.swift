//
//  TableViewCell.swift
//  ToDo
//
//  Created by Dagmawi Nadew-Assefa on 4/24/18.
//  Copyright © 2018 Sason. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupCell() {
        
    }

}
