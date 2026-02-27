//
//  SymbolDetailViewModel.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 26/02/2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SymbolDetailViewModel: ObservableObject {
    @Published var stock: StockSymbol
    @Published var priceHistory: [Double] = []
    @Published var isAnimating = false
    @Published var isLoading = false
    
    private let webSocketManager: WebSocketManaging
    private let symbol: String
    private var cancellables = Set<AnyCancellable>()
    
    init(stock: StockSymbol, webSocketManager: WebSocketManaging? = nil) {
        self.symbol = stock.symbol
        self.webSocketManager = webSocketManager ?? WebSocketManager.shared
        self.stock = stock
        self.priceHistory = [stock.currentPrice]
        
        setupWebSocketSubscription()
    }
    
    private func setupWebSocketSubscription() {
        webSocketManager.subscribeToSymbol(symbol)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] priceUpdate in
                self?.handlePriceUpdate(priceUpdate)
            }
            .store(in: &cancellables)
    }
    
    private func handlePriceUpdate(_ priceUpdate: PriceUpdate) {
        let previousPrice = stock.currentPrice
        stock.updatePrice(priceUpdate.price)
        
        if priceUpdate.price != previousPrice {
            priceHistory.append(priceUpdate.price)
            if priceHistory.count > 50 {
                priceHistory.removeFirst()
            }
            triggerPriceAnimation()
        }
    }
    
    deinit {
        let capturedSymbol = symbol
        DispatchQueue.main.async { [weak self] in
            self?.webSocketManager.unsubscribeFromSymbol(capturedSymbol)
        }
    }
    
    private func triggerPriceAnimation() {
        withAnimation(.easeInOut(duration: Constants.UI.priceUpdateAnimationDuration)) {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.UI.flashAnimationDuration) {
            withAnimation(.easeInOut(duration: Constants.UI.priceUpdateAnimationDuration)) {
                self.isAnimating = false
            }
        }
    }
    
    var priceChangeColor: Color {
        if isAnimating {
            return stock.isPriceUp ? .green : stock.isPriceDown ? .red : .primary
        }
        return .primary
    }
    
    var backgroundColor: Color {
        if isAnimating {
            return stock.isPriceUp ? .green.opacity(0.1) : stock.isPriceDown ? .red.opacity(0.1) : .clear
        }
        return .clear
    }
    
    var description: String {
        switch stock.symbol {
        case "AAPL":
            return "Apple Inc. is an American multinational technology company that specializes in consumer electronics, computer software, and online services."
        case "GOOGL":
            return "Alphabet Inc. is an American multinational conglomerate that was created through a corporate restructuring of Google."
        case "MSFT":
            return "Microsoft Corporation is an American multinational technology corporation which produces computer software, consumer electronics, and related services."
        case "AMZN":
            return "Amazon.com, Inc. is an American multinational technology company which focuses on e-commerce, cloud computing, digital streaming, and artificial intelligence."
        case "TSLA":
            return "Tesla, Inc. is an American electric vehicle and clean energy company based in Palo Alto, California."
        case "NVDA":
            return "NVIDIA Corporation is an American multinational technology company incorporated in Delaware and based in Santa Clara, California."
        default:
            return "\(stock.symbol) is a publicly traded company on the stock market. Real-time price updates are provided via WebSocket connection."
        }
    }
}

