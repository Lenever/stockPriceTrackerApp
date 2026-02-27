//
//  SymbolData.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import Foundation

struct SymbolData {
    static let stockSymbols = [
        "AAPL", "GOOGL", "MSFT", "AMZN", "TSLA", "NVDA", "META", "BRK.B", "LLY", "V",
        "JPM", "UNH", "XOM", "MA", "PG", "JNJ", "COST", "HD", "CVX", "ABBV",
        "MRK", "PEP", "KO", "TMO", "BAC", "AVGO", "WMT", "MCD", "CSCO", "ABT",
        "DHR", "VZ", "ADBE", "CRM", "NFLX", "ACN", "NKE", "CMCSA", "PFE", "INTC",
        "ORCL", "WFC", "QCOM", "IBM", "TXN", "HON", "AMD", "UPS", "LIN", "GE"
    ]
    
    static func getRandomSymbol() -> String {
        return stockSymbols.randomElement() ?? "AAPL"
    }
    
    static func getRandomPrice() -> Double {
        return Double.random(in: 50...500)
    }
    
    static func getRandomPriceChange() -> Double {
        return Double.random(in: -5...5)
    }
    
    static func createInitialStocks(count: Int = 25) -> [StockSymbol] {
        let symbols = Array(stockSymbols.prefix(count))
        return symbols.map { StockSymbol(symbol: $0) }
    }
}
