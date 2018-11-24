//
//  CurrencyListTableViewCell.swift
//  CurrencyList
//
//  Created by Gamze on 11/22/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation
import UIKit

class CurrencyListTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyRateTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
