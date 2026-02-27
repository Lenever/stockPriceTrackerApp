//
//  StockSymbol.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import Foundation

struct StockSymbol: Identifiable, Equatable {
    let id = UUID()
    let symbol: String
    var currentPrice: Double
    var previousPrice: Double
    var lastUpdateTime: Date
    
    var priceChange: Double {
        currentPrice - previousPrice
    }
    
    var priceChangePercent: Double {
        guard previousPrice != 0 else { return 0 }
        return (priceChange / previousPrice) * 100
    }
    
    var isPriceUp: Bool {
        priceChange > 0
    }
    
    var isPriceDown: Bool {
        priceChange < 0
    }
    
    var formattedPrice: String {
        String(format: "%.2f", currentPrice)
    }
    
    var formattedPriceChange: String {
        let change = String(format: "%.2f", abs(priceChange))
        let percent = String(format: "%.2f", abs(priceChangePercent))
        return "\(change) (\(percent)%)"
    }
    
    var priceChangeSymbol: String {
        isPriceUp ? "↑" : isPriceDown ? "↓" : "→"
    }
    
    init(symbol: String, currentPrice: Double = Double.random(in: 50...500)) {
        self.symbol = symbol
        self.currentPrice = currentPrice
        self.previousPrice = currentPrice
        self.lastUpdateTime = Date()
    }
    
    mutating func updatePrice(_ newPrice: Double) {
        previousPrice = currentPrice
        currentPrice = newPrice
        lastUpdateTime = Date()
    }
    
    static func == (lhs: StockSymbol, rhs: StockSymbol) -> Bool {
        lhs.id == rhs.id
    }
}
