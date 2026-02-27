//
//  SymbolDetailView.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 26/02/2026.
//

import SwiftUI

struct SymbolDetailView: View {
    @StateObject private var viewModel: SymbolDetailViewModel
    
    init(stock: StockSymbol) {
        self._viewModel = StateObject(wrappedValue: SymbolDetailViewModel(stock: stock))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.isLoading {
                    loadingView
                } else {
                    headerSection
                    priceSection
                    descriptionSection
                }
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Loading stock data...")
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(viewModel.stock.symbol)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Real-time Price Tracking")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var priceSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text(viewModel.stock.formattedPrice)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                
                Spacer()
            }
            
            HStack {
                Text(viewModel.stock.priceChangeSymbol)
                    .font(.title2)
                
                Text(viewModel.stock.formattedPriceChange)
                    .font(.title3)
                
                Spacer()
            }
            
            HStack {
                Text("Last updated:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(formatTime(viewModel.stock.lastUpdateTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(viewModel.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        SymbolDetailView(stock: StockSymbol(symbol: "AAPL"))
    }
}
