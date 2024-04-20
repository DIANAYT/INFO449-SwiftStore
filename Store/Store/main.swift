//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String {get}
    func price() -> Int
}

class Item: SKU {
    var name: String
    var itemPrice: Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.itemPrice = priceEach
    }
    
    func price() -> Int {
        return self.itemPrice
    }
    
}

class WeightedItem: SKU {
    var name: String
    var pricePerLb: Int
    var weight: Double
    
    init(name: String, priceEach: Int, weight: Double) {
        self.name = "\(name) (\(weight) lbs)"
        self.pricePerLb = priceEach
        self.weight = weight
    }
    
    func price() -> Int {
        return Int(Double(self.pricePerLb) * self.weight)
    }
    
}

class Receipt {
    private var itemsList: [SKU] = []
    
    func items() -> [SKU] {
        return itemsList
    }
    
    func output() -> String {
        var receipt = "Receipt:\n"
        for item in itemsList {
            receipt += "\(item.name): $\(Double(item.price()) / 100)\n"
        }
        receipt += "------------------\nTOTAL: $\(Double(self.total()) / 100)"
        return receipt
    }
    
    func add(_ item: SKU) {
        itemsList.append(item)
    }
    
    func total() -> Int {
        return itemsList.reduce(0, {x, y in x + y.price()})
    }
}

class Register {
    private var receipt = Receipt()
    
    func scan(_ item: SKU) {
        receipt.add(item)
    }
    
    func subtotal() -> Int {
        return receipt.total()
    }
    
    func total() -> Receipt {
        let finalReceipt = receipt
        receipt = Receipt()
        return finalReceipt
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}
