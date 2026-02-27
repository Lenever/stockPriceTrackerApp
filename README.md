# stockPriceTrackerApp
A simple app that tracks and displays real-time price updates for multiple stock symbols (e.g., NVDA, AAPL, GOOG, etc.) and supports a second screen for symbol details.
A demo for the stockPriceTracker ios app can be found [here](https://drive.google.com/file/d/1omcVZvh1BhkNCH9ZuBBs2bieriuRlizL/view?usp=sharing)

## 🎯 Key Features Summary

### Core Functionality
- ✅ Real-time stock price tracking for 25 symbols
- ✅ WebSocket integration with echo server(wss://ws.postman-echo.com/raw)
- ✅ 2-second update intervals
- ✅ Price sorting (highest to lowest)
- ✅ Symbol-specific detail views

### Architecture & Core Principles
- ✅ MVVM architecture with clear separation
- ✅ Swift 6 compatibility with @MainActor for thread-safe UI updates
- ✅ Combine framework for handling WebSocket streams and state bindings
- ✅ Protocol-based Dependency Injection for easy mocking and testing
- ✅ Type-safe navigation with NavigationStack

### User Experience
- ✅ Real-time price indicators with animations
- ✅ Visual connection status (🟢/🔴) and price flash animations (Green/Red)
- ✅ Start/stop feed control
- ✅ Pull-to-refresh functionality
- ✅ Dark mode support

### Project Structure
- ✅ Models: *StockSymbol*, *PriceUpdate*, *ConnectionStatus*
- ✅ Services: WebSocketManager (Singleton handling the single socket connection)
- ✅ Screens: Feed (List) and StockDetail (Individual tracking)
- ✅ Views: Reusable UI components like *StockRowView* and *ConnectionIndicator*

## 📱 Build Requirements

- **iOS 26.2+**
- **Xcode 26.2.0+**
- **Swift 5.0**

## 🛠️ Development Setup

1. Clone the repository
2. Open `priceTrackerApp.xcodeproj`
3. Select target device or simulator
4. Build and run (⌘R)

## Screenshots
<p float = "left">
<img src="https://drive.google.com/uc?export=view&id=1jSbJ39_nLkruYr_CPahdTABqNOZi1yT3" width = "300" >
<img src="https://drive.google.com/uc?export=view&id=1mSwo2VeEvmwF51wH8ts_FpNWcue0HWO5" width = "300" >
<img src="https://drive.google.com/uc?export=view&id=1HxvXGtkuop7EYlrw5QUFH1gbKk1X5_jo" width = "300" >
</p>
