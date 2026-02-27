//
//  Coordinator.swift
//  priceTrackerApp
//
//  Created by Ikechukwu Onuorah on 26/02/2026.
//

import Foundation
import Combine
import SwiftUI

class Coordinator: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    func push(page: Routes) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: Routes) -> some View {
        switch page {
        case .feed: FeedView()
        case .symbolDetail(let stock): SymbolDetailView(stock: stock)
        }
    }
}
