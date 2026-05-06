import SwiftUI

struct PracticeTasksView: View {
    var body: some View {
        TabView {
            Task15View()
                .tabItem {
                    Label("Данные", systemImage: "arrow.right.circle.fill")
                }
            
            Task17View()
                .tabItem {
                    Label("Книга", systemImage: "book.closed.fill")
                }
            
            Task19View()
                .tabItem {
                    Label("Вызовы", systemImage: "phone.arrow.up.right.fill")
                }
            
            Task21View()
                .tabItem {
                    Label("Адаптация", systemImage: "square.split.2x1.fill")
                }
        }
        .tint(.blue)
    }
}

// MARK: - Задание 1.5
struct Task15View: View {
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Исходные данные")) {
                    LabeledContent("Время", value: currentTime)
                    LabeledContent("Студент №", value: "5")
                }
                Section {
                    NavigationLink("Передать данные") {
                        Task15Detail(time: currentTime, num: 5)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Задание 1.5")
        }
    }
}

struct Task15Detail: View {
    let time: String
    let num: Int
    var body: some View {
        List {
            Section(header: Text("Результат")) {
                Text("Квадрат номера: **\(num * num)**")
                Text("Зафиксировано в: **\(time)**")
            }
        }
        .navigationTitle("Детали")
    }
}

// MARK: - Задание 1.7
struct Task17View: View {
    @State private var book = "100 Days of SwiftUI"
    @State private var quote = "нано банана"
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Информация")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Книга").font(.caption).foregroundColor(.secondary)
                        Text(book).fontWeight(.medium)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Цитата").font(.caption).foregroundColor(.secondary)
                        Text("\"\(quote)\"").italic()
                    }
                }
                Section {
                    Button("Изменить данные") { isEditing = true }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Задание 1.7")
            .sheet(isPresented: $isEditing) {
                EditBookSheet(book: $book, quote: $quote)
            }
        }
    }
}

struct EditBookSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var book: String
    @Binding var quote: String
    var body: some View {
        NavigationStack {
            Form {
                TextField("Название", text: $book)
                TextField("Цитата", text: $quote)
            }
            .navigationTitle("Редактирование")
            .toolbar {
                Button("Готово") { dismiss() }.bold()
            }
        }
    }
}

// MARK: - Задание 1.9
struct Task19View: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Действия")) {
                    Button { openURL(URL(string: "tel://89811112233")!) } label: {
                        HStack {
                            Image(systemName: "phone.fill").foregroundColor(.green).frame(width: 30)
                            Text("Позвонить").foregroundColor(.primary)
                        }
                    }
                    Button { openURL(URL(string: "https://apple.com")!) } label: {
                        HStack {
                            Image(systemName: "safari.fill").foregroundColor(.blue).frame(width: 30)
                            Text("Открыть Safari").foregroundColor(.primary)
                        }
                    }
                    Button { openURL(URL(string: "maps://?q=МИРЭА")!) } label: {
                        HStack {
                            Image(systemName: "map.fill").foregroundColor(.orange).frame(width: 30)
                            Text("Карты Apple").foregroundColor(.primary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Задание 1.9")
        }
    }
}

// MARK: - Задание 2.1
struct Task21View: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var selection = 0
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if sizeClass == .compact {
                    Picker("", selection: $selection) {
                        Text("Экран 1").tag(0)
                        Text("Экран 2").tag(1)
                    }
                    .pickerStyle(.segmented).padding()
                    
                    if selection == 0 { FragmentOne() } else { FragmentTwo() }
                } else {
                    HStack(spacing: 0) {
                        FragmentOne(); Divider(); FragmentTwo()
                    }
                }
            }
            .navigationTitle("Задание 2.1")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FragmentOne: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea(edges: .bottom)
            VStack {
                Image(systemName: "1.circle.fill").font(.largeTitle)
                Text("Первый фрагмент").font(.headline)
            }.foregroundColor(.white)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FragmentTwo: View {
    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea(edges: .bottom)
            VStack {
                Image(systemName: "2.circle.fill").font(.largeTitle)
                Text("Второй фрагмент").font(.headline)
            }.foregroundColor(.white)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview { PracticeTasksView() }
