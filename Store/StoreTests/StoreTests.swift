//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testAddSingleItem() {
        register.scan(Item(name: "Gum", priceEach: 99))
        XCTAssertEqual(99, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(99, receipt.total())
        let expectedReceipt = """
Receipt:
Gum: $0.99
------------------
TOTAL: $0.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testAddSingleItemAdditional() {
        register.scan(Item(name: "Redbull", priceEach: 499))
        XCTAssertEqual(499, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(499, receipt.total())
        let expectedReceipt = """
Receipt:
Redbull: $4.99
------------------
TOTAL: $4.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testWeightedItems() {
        register.scan(WeightedItem(name: "Apples", priceEach: 300, weight: 1.5))
        XCTAssertEqual(450, register.subtotal())
        register.scan(WeightedItem(name: "Apples", priceEach: 300, weight: 0.5))
        XCTAssertEqual(600, register.subtotal())
        register.scan(WeightedItem(name: "Ribeye", priceEach: 2999, weight: 1))
        XCTAssertEqual(3599, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(3599, receipt.total())

        let expectedReceipt = """
Receipt:
Apples (1.5 lbs): $4.5
Apples (0.5 lbs): $1.5
Ribeye (1.0 lbs): $29.99
------------------
TOTAL: $35.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
        
    }
}
