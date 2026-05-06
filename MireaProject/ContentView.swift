import SwiftUI
import WebKit

struct MireaProjectView: View {
    var body: some View {

        TabView {
            DataFragmentView()
                .tabItem {
                    Label("Отрасль", systemImage: "chart.bar.doc.horizontal")
                }
            
            WebViewFragment()
                .tabItem {
                    Label("Браузер", systemImage: "safari")
                }
        }
    }
}

// MARK: --
struct DataFragmentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Rectangle()
                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 200)
                        .cornerRadius(16)
                        .overlay(
                            Text("Data Science & Big Data")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Отрасль Data Science")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Наука о данных объединяет статистику, анализ данных и машинное обучение для понимания и анализа реальных явлений с помощью данных. Сегодня это одно из самых востребованных направлений в IT, активно применяющее Python, нейросети и предиктивную аналитику.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                        
                        Divider()
                        
                        Label("Ключевые технологии", systemImage: "cpu")
                            .font(.headline)
                        
                        HStack {
                            TechChip(title: "Python")
                            TechChip(title: "Machine Learning")
                            TechChip(title: "Big Data")
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Информация")
        }
    }
}

struct TechChip: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(20)
    }
}

// MARK: - WebView Фрагмент
struct WebViewFragment: View {
    @State private var urlString = "https://www.apple.com"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.green)
                    TextField("URL", text: $urlString)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                .padding(10)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                .padding()
                
                if let url = URL(string: urlString) {
                    SwiftUIWebView(url: url)
                        .edgesIgnoringSafeArea(.bottom)
                } else {
                    Text("Неверный URL")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Браузер")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SwiftUIWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

// MARK: --
#Preview {
    MireaProjectView()
}
