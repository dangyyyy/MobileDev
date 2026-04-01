import SwiftUI
import OSLog
import UserNotifications

// MARK: - Главный экран
struct MainView: View {
    
    @State private var path = NavigationPath()
    @State private var inputText: String = ""
    
    @State private var showAlert = false
    @State private var showTimePicker = false
    @State private var showDatePicker = false
    @State private var showProgress = false
    
    @State private var showResult = false
    @State private var resultText = ""
    
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                
                Section("Ввод") {
                    TextField("Введите текст", text: $inputText)
                }
                
                Section("Навигация") {
                    Button {
                        path.append(AppScreen.second(text: inputText))
                    } label: {
                        Label {
                            Text("Перейти на второй экран").foregroundColor(.black)
                        } icon: {
                            Image(systemName: "arrow.right.circle").foregroundColor(.blue)
                        }
                    }
                }
                
                Section("Диалоги") {
                    
                    Button {
                        showAlert = true
                    } label: {
                        Label {
                            Text("Показать Alert").foregroundColor(.black)
                        } icon: {
                            Image(systemName: "exclamationmark.bubble").foregroundColor(.blue)
                        }
                    }
                    
                    Button {
                        showTimePicker = true
                    } label: {
                        Label {
                            Text("Выбор времени").foregroundColor(.black)
                        } icon: {
                            Image(systemName: "clock").foregroundColor(.blue)
                        }
                    }
                    
                    Button {
                        showDatePicker = true
                    } label: {
                        Label {
                            Text("Выбор даты").foregroundColor(.black)
                        } icon: {
                            Image(systemName: "calendar").foregroundColor(.blue)
                        }
                    }
                    
                    Button {
                        showProgress = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showProgress = false
                            
                            resultText = "Загрузка завершена"
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showResult = true
                            }
                        }
                    } label: {
                        Label {
                            Text("Показать загрузку").foregroundColor(.black)
                        } icon: {
                            Image(systemName: "hourglass").foregroundColor(.blue)
                        }
                    }
                }
                
                Section("Уведомления") {
                    Button {
                        sendLocalPush()
                    } label: {
                        Label {
                            Text("Push через 5 сек").foregroundColor(.black)
                        } icon: {
                            Image(systemName: "bell.badge").foregroundColor(.blue)
                        }
                    }
                }
                
                Section("Системные") {
                    ShareLink(item: "Лоллин Даниил Владиславович: \(inputText)") {
                        Label {
                            Text("Поделиться").foregroundColor(.black)
                        } icon: {
                            Image(systemName: "square.and.arrow.up").foregroundColor(.blue)
                        }
                    }
                    
                    Link(destination: URL(string: "https://www.mirea.ru")!) {
                        Label {
                            Text("Открыть сайт МИРЭА").foregroundColor(.black)
                        } icon: {
                            Image(systemName: "safari").foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Практика 2")
            
            .navigationDestination(for: AppScreen.self) { screen in
                if case .second(let text) = screen {
                    SecondView(receivedText: text)
                }
            }
            
            .alert("Здравствуй, МИРЭА!", isPresented: $showAlert) {
                
                Button("Иду дальше") {
                    resultText = "Нажато: Иду дальше"
                    withAnimation(.spring()) {
                        showResult = true
                    }
                }
                
                Button("На паузе") {
                    resultText = "Нажато: На паузе"
                    withAnimation(.spring()) {
                        showResult = true
                    }
                }
                
                Button("Нет", role: .cancel) {
                    resultText = "Нажато: Нет"
                    withAnimation(.spring()) {
                        showResult = true
                    }
                }
                
            } message: {
                Text("Сделаем практику?")
            }
            
            .sheet(isPresented: $showTimePicker) {
                TimePickerView { selectedTime in
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    
                    resultText = "Время: \(formatter.string(from: selectedTime))"
                    withAnimation(.spring()) {
                        showResult = true
                    }
                }
            }
            
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker("Выберите дату", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    
                    Button("Готово") {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        
                        resultText = "Дата: \(formatter.string(from: selectedDate))"
                        
                        showDatePicker = false
                        
                        withAnimation(.spring()) {
                            showResult = true
                        }
                    }
                }
                .presentationDetents([.medium])
            }
            
            .overlay {
                
                if showProgress {
                    ZStack {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("Загрузка...")
                                .font(.subheadline)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                    }
                }
                
                if showResult {
                    ZStack {
                        Color.black.opacity(0.25)
                            .ignoresSafeArea()
                            .transition(.opacity)
                            .onTapGesture {
                                withAnimation {
                                    showResult = false
                                }
                            }
                        
                        VStack(spacing: 16) {
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                                .scaleEffect(showResult ? 1 : 0.5)
                                .opacity(showResult ? 1 : 0)
                                .animation(.easeOut(duration: 0.3).delay(0.1), value: showResult)
                            
                            Text("Результат")
                                .font(.headline)
                                .opacity(showResult ? 1 : 0)
                                .animation(.easeIn.delay(0.1), value: showResult)
                            
                            Text(resultText)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .opacity(showResult ? 1 : 0)
                                .animation(.easeIn.delay(0.15), value: showResult)
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    showResult = false
                                }
                            } label: {
                                Text("ОК")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .opacity(showResult ? 1 : 0)
                            .animation(.easeIn.delay(0.2), value: showResult)
                        }
                        .padding()
                        .frame(maxWidth: 280)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .scaleEffect(showResult ? 1 : 0.7)
                        .opacity(showResult ? 1 : 0)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
    }
}
