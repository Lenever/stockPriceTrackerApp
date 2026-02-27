//
//  WebSocketManager.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import Foundation
import Combine
import SwiftUI

class WebSocketManager: ObservableObject {
    static let shared = WebSocketManager()
    
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var receivedUpdates: [PriceUpdate] = []
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    private let url = Constants.WebSocket.echoServerURL
    private let updateInterval = Constants.WebSocket.updateInterval
    
    private var symbolSubjects: [String: PassthroughSubject<PriceUpdate, Never>] = [:]
    
    private init() {}
    
    deinit {
//        disconnect()
        timer?.invalidate()
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func connect() {
        guard connectionStatus != .connected else { return }
        
        connectionStatus = .connecting
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessage()
        startPriceUpdates()
    }
    
    func disconnect() {
        timer?.invalidate()
        timer = nil
        
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        
        connectionStatus = .disconnected
    }
    
    func startPriceUpdates() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.generateAndSendPriceUpdate()
            }
        }
    }
    
    func stopPriceUpdates() {
        timer?.invalidate()
        timer = nil
    }
    
    private func generateAndSendPriceUpdate() {
        let symbol = SymbolData.getRandomSymbol()
        let newPrice = SymbolData.getRandomPrice()
        let priceUpdate = PriceUpdate(symbol: symbol, price: newPrice)
        
        sendMessage(priceUpdate)
    }
    
    private func sendMessage(_ priceUpdate: PriceUpdate) {
        guard let jsonString = priceUpdate.jsonString else { return }
        
        let message = URLSessionWebSocketTask.Message.string(jsonString)
        webSocketTask?.send(message) { [weak self] error in
            if let error = error {
                Task { @MainActor in
                    self?.connectionStatus = .error(error.localizedDescription)
                }
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let message):
                    self?.handleReceivedMessage(message)
                    self?.receiveMessage()
                case .failure(let error):
                    self?.connectionStatus = .error(error.localizedDescription)
                }
            }
        }
    }
    
    private func handleReceivedMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            if let priceUpdate = PriceUpdate.from(jsonString: text) {
                receivedUpdates.append(priceUpdate)
                connectionStatus = .connected
                broadcastSymbolUpdate(priceUpdate)
            }
        case .data(let data):
            if let text = String(data: data, encoding: .utf8),
               let priceUpdate = PriceUpdate.from(jsonString: text) {
                receivedUpdates.append(priceUpdate)
                connectionStatus = .connected
                broadcastSymbolUpdate(priceUpdate)
            }
        @unknown default:
            break
        }
    }
    
    private func broadcastSymbolUpdate(_ priceUpdate: PriceUpdate) {
        if let subject = symbolSubjects[priceUpdate.symbol] {
            subject.send(priceUpdate)
        }
    }
    
    func subscribeToSymbol(_ symbol: String) -> AnyPublisher<PriceUpdate, Never> {
        if symbolSubjects[symbol] == nil {
            symbolSubjects[symbol] = PassthroughSubject<PriceUpdate, Never>()
        }
        return symbolSubjects[symbol]?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }
    
    func unsubscribeFromSymbol(_ symbol: String) {
        symbolSubjects[symbol]?.send(completion: .finished)
        symbolSubjects.removeValue(forKey: symbol)
    }
    
    func toggleConnection() {
        switch connectionStatus {
        case .connected, .connecting:
            disconnect()
        case .disconnected, .error:
            connect()
        }
    }
}
