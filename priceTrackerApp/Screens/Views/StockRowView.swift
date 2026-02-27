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
                    .foregroundColor(priceColor)
                
                HStack(spacing: 4) {
                    Text(stock.priceChangeSymbol)
                        .font(.caption)
                        .foregroundColor(priceColor)
                    
                    Text(stock.formattedPriceChange)
                        .font(.caption)
                        .foregroundColor(priceColor)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(backgroundColor)
        .animation(.easeInOut(duration: Constants.UI.flashAnimationDuration), value: stock.priceChange)
        .onAppear {
            triggerAnimation()
        }
        .onChange(of: stock.priceChange) {
            triggerAnimation()
        }
    }
    
    private var priceColor: Color {
        if isAnimating {
            return stock.isPriceUp ? .green : stock.isPriceDown ? .red : .primary
        }
        return .primary
    }
    
    private var backgroundColor: Color {
        if isAnimating {
            return stock.isPriceUp ? .green.opacity(0.1) : stock.isPriceDown ? .red.opacity(0.1) : .clear
        }
        return .clear
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func triggerAnimation() {
        withAnimation(.easeInOut(duration: Constants.UI.flashAnimationDuration)) {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.UI.flashAnimationDuration) {
            withAnimation(.easeInOut(duration: Constants.UI.flashAnimationDuration)) {
                isAnimating = false
            }
        }
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
