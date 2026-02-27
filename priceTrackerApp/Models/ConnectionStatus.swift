//
//  ConnectionStatus.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import Foundation

enum ConnectionStatus: Equatable {
    case connected
    case disconnected
    case connecting
    case error(String)
    
    var isConnected: Bool {
        switch self {
        case .connected:
            return true
        default:
            return false
        }
    }
    
    var displayText: String {
        switch self {
        case .connected:
            return "Connected"
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting..."
        case .error(let message):
            return "Error: \(message)"
        }
    }
    
    var emoji: String {
        switch self {
        case .connected:
            return "🟢"
        case .disconnected:
            return "🔴"
        case .connecting:
            return "🟡"
        case .error:
            return "❌"
        }
    }
}
