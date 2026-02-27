//
//  StockRowView.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import SwiftUI

struct StockRowView: View {
    let stock: StockSymbol
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.symbol)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(formatTime(stock.lastUpdateTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(stock.formattedPrice)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                HStack(spacing: 4) {
                    Text(stock.priceChangeSymbol)
                        .font(.caption)
                    
                    Text(stock.formattedPriceChange)
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    VStack(spacing: 8) {
        StockRowView(stock: StockSymbol(symbol: "AAPL", currentPrice: 150.25))
        StockRowView(stock: StockSymbol(symbol: "GOOGL", currentPrice: 2500.50))
        StockRowView(stock: StockSymbol(symbol: "TSLA", currentPrice: 800.75))
    }
    .padding()
}
