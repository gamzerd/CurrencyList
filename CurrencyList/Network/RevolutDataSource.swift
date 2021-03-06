//
//  RevolutDataSource.swift
//  CurrencyList
//
//  Created by Gamze on 11/21/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

class RevolutDataSource: DataSource {
    
    var api: Service
    
    init() {
        self.api = Service(url: "https://revolut.duckdns.org/")
    }
    
    func getRates(base: String, callback: @escaping (CurrencyData?, Error?) -> Void){
        
        let params = CurrencyParams(base: base)
        
        self.api.get(path: "latest", params: params, responseType: CurrencyResponse.self, callback:
            { (data: CurrencyResponse?, error: Error?) -> Void in
                callback(data, nil)
            })
        
    }
    
}
