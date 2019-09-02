//
//  AutoCompleteCell.swift
//  RxDelegateProxy
//
//  Created by tskim on 02/09/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

class AutoCompleteCell: UITableViewCell {
    
    static let reusableKey = "AutoCompleteCell"
    let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(title)
        title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
