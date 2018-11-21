//
//  CurrencyRequest.swift
//  CurrencyList
//
//  Created by Gamze on 11/21/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

class CurrencyRequest: Encodable {
    var base: String
    
    init(base: String) {
        self.base = base
    }
}
