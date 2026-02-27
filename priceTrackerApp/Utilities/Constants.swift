//
//  Constants.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import Foundation

struct Constants {
    struct WebSocket {
        static let echoServerURL = URL(string: "wss://ws.postman-echo.com/raw")!
        static let updateInterval: TimeInterval = 2.0
    }
    
    struct UI {
        static let flashAnimationDuration: Double = 1.0
        static let priceUpdateAnimationDuration: Double = 0.3
    }
}
