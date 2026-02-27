//
//  WebSocketManaging.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import Foundation
import Combine

protocol WebSocketManaging {
    var connectionStatusPublisher: Published<ConnectionStatus>.Publisher { get }
    var receivedUpdatesPublisher: Published<[PriceUpdate]>.Publisher { get }
    
    func connect()
    func disconnect()
    func toggleConnection()
    
    func subscribeToSymbol(_ symbol: String) -> AnyPublisher<PriceUpdate, Never>
    func unsubscribeFromSymbol(_ symbol: String)
}
