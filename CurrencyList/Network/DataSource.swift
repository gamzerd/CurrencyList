//
//  DataSource.swift
//  CurrencyList
//
//  Created by Gamze on 11/25/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

protocol DataSource {

    /**
     * Retrieves the rate data from.
     */
    func getRates(base: String, callback: @escaping (CurrencyData?, Error?) -> Void)
}
