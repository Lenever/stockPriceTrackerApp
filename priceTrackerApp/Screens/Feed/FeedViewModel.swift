//
//  FeedViewModel.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 26/02/2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    @Published var stocks: [StockSymbol] = []
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var isLoading = false
    
    private let webSocketManager: WebSocketManaging
    private var cancellables = Set<AnyCancellable>()
    
    init(webSocketManager: WebSocketManaging? = nil) {
        self.webSocketManager = webSocketManager ?? WebSocketManager.shared
        setupWebSocketBindings()
        loadInitialStocks()
    }
    
    private func setupWebSocketBindings() {
        webSocketManager.connectionStatusPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$connectionStatus)
        
        webSocketManager.receivedUpdatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updates in
                self?.handlePriceUpdates(updates)
            }
            .store(in: &cancellables)
    }
    
    private func loadInitialStocks() {
        isLoading = true
        stocks = SymbolData.createInitialStocks(count: 25)
        stocks.sort { $0.currentPrice > $1.currentPrice }
        isLoading = false
    }
    
    private func handlePriceUpdates(_ updates: [PriceUpdate]) {
        for update in updates {
            updateStockPrice(for: update.symbol, newPrice: update.price)
        }
    }
    
    private func updateStockPrice(for symbol: String, newPrice: Double) {
        if let index = stocks.firstIndex(where: { $0.symbol == symbol }) {
            stocks[index].updatePrice(newPrice)
            sortStocks()
        }
    }
    
    private func sortStocks() {
        stocks.sort { $0.currentPrice > $1.currentPrice }
    }
    
    func toggleConnection() {
        webSocketManager.toggleConnection()
    }
    
    func connect() {
        webSocketManager.connect()
    }
    
    func disconnect() {
        webSocketManager.disconnect()
    }
    
    func getStock(for symbol: String) -> StockSymbol? {
        return stocks.first { $0.symbol == symbol }
    }
    
    func refreshStocks() {
        loadInitialStocks()
    }
    
}
