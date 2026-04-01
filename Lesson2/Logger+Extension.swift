import SwiftUI
import OSLog

// MARK: - Логирование
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let lifecycle = Logger(subsystem: subsystem, category: "Lifecycle")
}
