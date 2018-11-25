//
//  CurrencyData.swift
//  CurrencyList
//
//  Created by Gamze on 11/21/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

class CurrencyData: Codable, Equatable {
    
    var base: String = ""
    var date: String = ""
    var rates: Dictionary = [String: Float]()

    static func == (lhs: CurrencyData, rhs: CurrencyData) -> Bool {
        return lhs.base == rhs.base && lhs.date == rhs.date && lhs.rates == rhs.rates
    }
}
