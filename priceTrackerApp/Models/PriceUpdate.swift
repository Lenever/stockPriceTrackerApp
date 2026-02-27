//
//  PriceUpdate.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import Foundation

struct PriceUpdate: Codable {
    let symbol: String
    let price: Double
    let timestamp: Date
    
    init(symbol: String, price: Double) {
        self.symbol = symbol
        self.price = price
        self.timestamp = Date()
    }
    
    var jsonString: String? {
        guard let data = try? JSONEncoder().encode(self),
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }
    
    static func from(jsonString: String) -> PriceUpdate? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(PriceUpdate.self, from: data)
    }
}
