//
//  CurrencyData.swift
//  CurrencyList
//
//  Created by Gamze on 11/21/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

class CurrencyData: Codable {
    
    var base: String = ""
    var date: String = ""
    var rates: Dictionary = [String: Float]()
    
}
