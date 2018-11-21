//
//  Rate.swift
//  CurrencyList
//
//  Created by Gamze on 11/21/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation
class Rate: NSObject {
    
    var id: String = ""
    var value: Float = 0

    init(id: String, value: Float) {
        self.id = id
        self.value = value
    }
}
