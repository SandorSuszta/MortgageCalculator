import Foundation

extension Formatter {
    static let MCPriceFormatter: Formatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.maximumIntegerDigits = 7
        formatter.numberStyle = .currency
        formatter.currencyCode = "GBP"
        return formatter
    }()
}
