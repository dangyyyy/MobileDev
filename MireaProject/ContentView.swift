import SwiftUI
import WebKit

// MARK: - Главное View
struct MireaProjectView: View {
    var body: some View {
        TabView {
            DataFragmentView()
                .tabItem { Label("Отрасль", systemImage: "chart.bar.doc.horizontal") }
            WebViewFragment()
                .tabItem { Label("Браузер", systemImage: "safari") }
            WorkerFragmentView()
                .tabItem { Label("Синхронизация", systemImage: "arrow.triangle.2.circlepath") }
        }
    }
}

// MARK: - Вкладка 1
struct DataFragmentView: View {
    let techs = ["Python", "Machine Learning", "Big Data", "TensorFlow", "SQL"]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 180)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Data Science")
                                .font(.largeTitle).fontWeight(.bold).foregroundStyle(.white)
                            Text("& Big Data")
                                .font(.title2).fontWeight(.semibold).foregroundStyle(.white.opacity(0.85))
                        }
                        .padding(20)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Отрасль Data Science")
                            .font(.headline)
                        Text("Наука о данных объединяет статистику, анализ данных и машинное обучение для понимания реальных явлений. Одно из самых востребованных направлений в IT.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineSpacing(3)
                    }
                    .padding(.vertical, 4)
                }

                Section("Ключевые технологии") {
                    ForEach(techs, id: \.self) { tech in
                        Label(tech, systemImage: "cpu")
                    }
                }

                Section("Статистика рынка") {
                    InfoRow(icon: "person.3.fill", color: .blue, title: "Специалистов в РФ", value: "45 000+")
                    InfoRow(icon: "rublesign.circle.fill", color: .green, title: "Средняя зарплата", value: "180 000 ₽")
                    InfoRow(icon: "chart.line.uptrend.xyaxis", color: .orange, title: "Рост спроса", value: "+34% в год")
                    InfoRow(icon: "building.2.fill", color: .purple, title: "Компаний нанимает", value: "2 400+")
                }
            }
            .navigationTitle("Data Science")
        }
    }
}

struct InfoRow: View {
    let icon: String
    let color: Color
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 28)
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
    }
}

// MARK: - Вкладка 2
struct WebViewFragment: View {
    @State private var urlString = "https://www.apple.com"
    @State private var committed = "https://www.apple.com"

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    TextField("URL", text: $urlString, onCommit: { committed = urlString })
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .font(.subheadline)
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .padding(.vertical, 8)

                Divider()

                if let url = URL(string: committed) {
                    SwiftUIWebView(url: url)
                } else {
                    ContentUnavailableView("Неверный URL", systemImage: "link.badge.plus")
                }
            }
            .navigationTitle("Браузер")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SwiftUIWebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ uiView: WKWebView, context: Context) { uiView.load(URLRequest(url: url)) }
}

// MARK: - Вкладка 3
struct WorkerFragmentView: View {
    struct SyncTask: Identifiable {
        let id = UUID()
        let icon: String
        let color: Color
        let title: String
        var status: Status = .idle
        var lastSync: Date? = nil

        enum Status { case idle, running, done }
    }

    @State private var tasks: [SyncTask] = [
        SyncTask(icon: "chart.bar.fill",       color: .blue,   title: "Статистика рынка"),
        SyncTask(icon: "person.3.fill",        color: .purple, title: "Данные о вакансиях"),
        SyncTask(icon: "books.vertical.fill",  color: .orange, title: "Учебные материалы"),
        SyncTask(icon: "newspaper.fill",       color: .red,    title: "Новости отрасли"),
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Задачи синхронизации") {
                    ForEach($tasks) { $task in
                        SyncTaskRow(task: $task)
                    }
                }

                Section {
                    Button {
                        runAll()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Синхронизировать всё", systemImage: "arrow.triangle.2.circlepath")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(tasks.contains { $0.status == .running })
                }
            }
            .navigationTitle("Синхронизация")
        }
    }

    func runAll() {
        for i in tasks.indices {
            runTask(at: i, delay: UInt64(i) * 800_000_000)
        }
    }

    func runTask(at index: Int, delay: UInt64 = 0) {
        tasks[index].status = .running
        Task.detached(priority: .background) {
            try? await Task.sleep(nanoseconds: delay + 1_500_000_000)
            await MainActor.run {
                tasks[index].status = .done
                tasks[index].lastSync = Date()
            }
        }
    }
}

struct SyncTaskRow: View {
    @Binding var task: WorkerFragmentView.SyncTask

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.icon)
                .foregroundStyle(task.color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.body)
                if let date = task.lastSync {
                    Text("Обновлено \(date.formatted(.dateTime.hour().minute()))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Не синхронизировано")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            switch task.status {
            case .idle:
                Image(systemName: "circle")
                    .foregroundStyle(.secondary)
            case .running:
                ProgressView()
            case .done:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview("Приложение") { MireaProjectView() }
#Preview("Отрасль") { DataFragmentView() }
#Preview("Браузер") { WebViewFragment() }
#Preview("Синхронизация") { WorkerFragmentView() }
