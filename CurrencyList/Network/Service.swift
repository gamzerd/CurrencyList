//
//  Service.swift
//  CurrencyList
//
//  Created by Gamze on 11/21/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

class Service: NSObject {
    
    var url: String
    
    init(url: String) {
        self.url = url
    }
    
    func get<E, D>(path: String, params: E, responseType: D.Type, callback: @escaping (D?, Error?) -> Void) where E: Encodable, D : Decodable {
        
        // build URL
        let endpoint = self.url + path
        let urlComponents = NSURLComponents(string: endpoint)!
        
        // encode the params and decode it to [String:String] to build the query parameters
        var paramMap: [String:String] = [:]
        do {
            let encodedData = try JSONEncoder().encode(params)
            paramMap = try JSONDecoder().decode([String:String].self, from: encodedData)
        } catch {
           // return error
            callback(nil, error)
            return
        }
        
        // add each key to query parameters
        urlComponents.queryItems = paramMap.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = URLRequest(url: urlComponents.url!)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                
                // return result to the callback
                callback(decodedResponse, nil)
            } catch {
                // return error
                callback(nil, error)
            }
        }
        
        task.resume()
    }
}
