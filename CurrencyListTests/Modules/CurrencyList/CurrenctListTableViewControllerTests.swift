//
//  CurrenctListTableViewControllerTests.swift
//  CurrencyListTests
//
//  Created by Gamze on 11/25/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import XCTest
@testable import CurrencyList

class CurrenctListTableViewControllerTests: XCTestCase {
    
    var vc: CurrencyList.CurrencyListTableViewController!

    override func setUp() {
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vcList = storyboard.instantiateViewController(withIdentifier: "CurrencyListTableViewControllerID")
        vc = vcList as? CurrencyList.CurrencyListTableViewController
        // _ = vc.view // To call viewDidLoad when needed
    }
    
    func testViewDidLoad() {
        let vm = MockViewModel()
        vc.viewModel = vm
        
        XCTAssertNil(vc!.viewModel.showDataClosure)
        XCTAssertEqual(vm.fetchPageDataCallCount, 0)

        _ = vc!.view // To call viewDidLoad

        // the showDataClosure must be set
        XCTAssertNotNil(vc!.viewModel.showDataClosure)
        
        // the fetchPageData() of view model must have been called
        XCTAssertEqual(vm.fetchPageDataCallCount, 1)
    }
    
    func testReloadTableViewAndFocusToFirstRow() {
        let vm = MockViewModel()
        
        vc.viewModel = vm
        
        XCTAssertTrue(vc!.cellDictionary.isEmpty)
        XCTAssertEqual(0, vc.tableView(vc.tableView, numberOfRowsInSection: 0))
        
        vm.rateList = [
            CurrencyList.Rate(id: "TRY", value: 56.6),
            CurrencyList.Rate(id: "EUR", value: 3.0),
            CurrencyList.Rate(id: "CAD", value: 28.2)
        ]
        
        XCTAssertEqual(3, vc.tableView(vc.tableView, numberOfRowsInSection: 0))
    }
    
    func testGetCurrencyWithFormat() {
        
        XCTAssertEqual(vc.getCurrencyWithFormat(comingAmount: 0), "")
        XCTAssertEqual(vc.getCurrencyWithFormat(comingAmount: 5.0), "5")
        XCTAssertEqual(vc.getCurrencyWithFormat(comingAmount: 6.3), "6.3")
        XCTAssertEqual(vc.getCurrencyWithFormat(comingAmount: 9.864), "9.86")
        XCTAssertEqual(vc.getCurrencyWithFormat(comingAmount: 9.866), "9.87")
    }
}

class MockViewModel: CurrencyList.CurrencyViewModel {
    
    var showDataClosure: (() -> ())?
    
    var showErrorClosure: (() -> ())?
    
    var baseRate: CurrencyList.Rate = CurrencyList.Rate(id: "GBP", value: 1.0)
    
    var rateList: [CurrencyList.Rate] = []
    
    var fetchPageDataCallCount = 0
    func fetchPageData() {
        fetchPageDataCallCount += 1
    }
    
    func didSelectNewCurrency(index: Int) {
        
    }
    
    func didChangeTextField(index: Int, valueOfChangedItem: Float) {
        
    }
    
    func reset() {
        
    }
    
}
