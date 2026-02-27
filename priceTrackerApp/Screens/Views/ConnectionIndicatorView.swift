//
//  ConnectionIndicatorView.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import SwiftUI

struct ConnectionIndicatorView: View {
    let status: ConnectionStatus
    
    var body: some View {
        HStack(spacing: 8) {
            Text(status.emoji)
                .font(.title3)
            
            Text(status.displayText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        ConnectionIndicatorView(status: .connected)
        ConnectionIndicatorView(status: .disconnected)
        ConnectionIndicatorView(status: .connecting)
        ConnectionIndicatorView(status: .error("Network error"))
    }
    .padding()
}
