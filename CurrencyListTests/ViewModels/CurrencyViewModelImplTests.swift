//
//  CurrencyListTests.swift
//  CurrencyListTests
//
//  Created by Gamze on 11/20/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import XCTest
@testable import CurrencyList

class CurrencyViewModelImplTests: XCTestCase {

    func testDidResponseReceive() {
        
        let data = CurrencyData()
        data.base = "GBP"
        data.rates = [
            "EUR": 1.1
        ]
        
        let vm = CurrencyViewModelImpl()
        vm.baseRate = Rate(id: "GBP", value: 1.0)
        
        vm.didResponseReceive(data: data, error: nil)
        
        // data should not be nil and should be equal to the given data
        XCTAssertNotNil(vm.data)
        XCTAssertEqual(data, vm.data)
        
        // rateList should be defined and it must contain one more item than the keys in rate list
        XCTAssertNotNil(vm.rateList)
        XCTAssertEqual(vm.rateList.count, 2)
        
        // first item of the rateList must be the base currency
        XCTAssertEqual(vm.rateList[0].id, vm.baseRate.id)
        XCTAssertEqual(vm.rateList[0].value, vm.baseRate.value)
        
        // second item of the rateList must be the first item in the data.rates
        XCTAssertEqual(vm.rateList[1].id, "EUR")
        XCTAssertEqual(vm.rateList[1].value, 1.1)
    }

    func testDidSelectNewCurrency() {
        
        let vm = CurrencyViewModelImpl()
        vm.baseRate = Rate(id: "AUD", value: 13.0)
        vm.rateList = [
            Rate(id: "TRY", value: 56.6),
            Rate(id: "EUR", value: 3.0),
            Rate(id: "CAD", value: 28.2)
        ]
        
        vm.dataSource = MockDataSource()
        vm.didSelectNewCurrency(index: 2)
        
        XCTAssertNotNil(vm.baseRate)
        XCTAssertEqual(vm.baseRate, vm.rateList[2])
        XCTAssertEqual((vm.dataSource as! MockDataSource).callCount, 1)
    }
    
    func testdidChangeTextFieldIfIndexZero() {
        
        let vm = CurrencyViewModelImpl()
        vm.baseRate = Rate(id: "GBP", value: 1.0)
        vm.rateList = [
            Rate(id: "GBP", value: 1.0),
            Rate(id: "TRY", value: 6.6),
            Rate(id: "EUR", value: 1.1)
        ]
        
        let data = CurrencyData()
        data.base = "GBP"
        data.rates = [
            "TRY": 6.6,
            "EUR": 1.1,
        ]
        vm.data = data
        
        vm.didChangeTextField(index: 0, valueOfChangedItem: 2)
        
        XCTAssertEqual(vm.baseRate.value, 2)
        XCTAssertEqual(vm.rateList[0].value, 2.0)
        XCTAssertEqual(vm.rateList[1].value, 13.2)
        XCTAssertEqual(vm.rateList[2].value, 2.2)
    }
    
    func testdidChangeTextField() {
        
        let vm = CurrencyViewModelImpl()
        vm.baseRate = Rate(id: "GBP", value: 1.0)
        vm.rateList = [
            vm.baseRate,
            Rate(id: "TRY", value: 6.6),
            Rate(id: "EUR", value: 1.1)
        ]
        
        let data = CurrencyData()
        data.base = "GBP"
        data.rates = [
            "TRY": 6.6,
            "EUR": 1.1,
        ]
        vm.data = data
        
        vm.didChangeTextField(index: 2, valueOfChangedItem: 3.3)
        
        XCTAssertEqual(vm.baseRate.value, 3.0)
        XCTAssertEqual(vm.rateList[0].value, 3.0)
        XCTAssertEqual(vm.rateList[1].value, 19.8)
        XCTAssertEqual(vm.rateList[2].value, 3.3)
    }
}

class MockDataSource: DataSource {
    
    var callCount = 0
    
    func getRates(base: String, callback: @escaping (CurrencyData?, Error?) -> Void) {
        callCount += 1
    }
}
