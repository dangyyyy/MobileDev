import SwiftUI
import OSLog

// MARK: - Второй экран
struct SecondView: View {
    let receivedText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Получено:")
            Text(receivedText.isEmpty ? "Пусто" : receivedText)
                .font(.title)
                .bold()
        }
        .navigationTitle("Второй экран")
    
        .onAppear {
            Logger.lifecycle.info("SecondView: onAppear")
        }
        .onDisappear {
            Logger.lifecycle.info("SecondView: onDisappear")
        }
    }
}
