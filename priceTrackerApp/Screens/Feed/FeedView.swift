//
//  FeedView.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 26/02/2026.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            if viewModel.isLoading {
                loadingView
            } else {
                stockListView
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            ConnectionIndicatorView(status: viewModel.connectionStatus)
            
            Spacer()
            
            ToggleButtonView(
                isConnected: viewModel.connectionStatus.isConnected,
                onToggle: {
                    viewModel.toggleConnection()
                }
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(radius: 1)
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Loading stocks...")
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
    
    private var stockListView: some View {
        List(viewModel.stocks) { stock in
            StockRowView(stock: stock)
                .contentShape(Rectangle())
                .onTapGesture {
                    coordinator.push(page: .stockDetails(stock.symbol))
                }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            viewModel.refreshStocks()
        }
    }
}

#Preview {
    FeedView()
}
