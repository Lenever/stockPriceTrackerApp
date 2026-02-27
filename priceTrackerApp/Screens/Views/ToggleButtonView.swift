//
//  ToggleButtonView.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 27/02/2026.
//

import SwiftUI

struct ToggleButtonView: View {
    let isConnected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 8) {
                Image(systemName: isConnected ? "stop.circle.fill" : "play.circle.fill")
                    .font(.title3)
                
                Text(isConnected ? "Stop" : "Start")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(buttonColor)
            )
            .foregroundColor(.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var buttonColor: Color {
        isConnected ? .red : .green
    }
}

#Preview {
    VStack(spacing: 16) {
        ToggleButtonView(isConnected: false) {
            print("Start tapped")
        }
        
        ToggleButtonView(isConnected: true) {
            print("Stop tapped")
        }
    }
    .padding()
}
