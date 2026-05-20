import SwiftUI
import CryptoKit
import Observation

// MARK: - 1. ViewBinding → Музыкальный плеер

struct MusicPlayerView: View {
    @State private var isPlaying = false
    @State private var progress: Double = 0.0
    @State private var volume: Double = 0.7

    func timeLabel(_ ratio: Double) -> String {
        let total = Int(ratio * 180)
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.12))
                            .frame(width: 180, height: 180)
                        Image(systemName: "music.note")
                            .font(.system(size: 72, weight: .light))
                            .foregroundStyle(.blue)
                            .rotationEffect(.degrees(isPlaying ? 360 : 0))
                            .animation(
                                isPlaying
                                    ? .linear(duration: 6).repeatForever(autoreverses: false)
                                    : .default,
                                value: isPlaying
                            )
                    }
                    VStack(spacing: 4) {
                        Text("Эльбрус Джанмирзоев").font(.title3.bold())
                        Text("Чародейка").font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
            }

            Section {
                VStack(spacing: 4) {
                    Slider(value: $progress, in: 0...1) { _ in }
                        .tint(.blue)
                    HStack {
                        Text(timeLabel(progress)).font(.caption2).foregroundStyle(.secondary)
                        Spacer()
                        Text("-\(timeLabel(1 - progress))").font(.caption2).foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)

                HStack(spacing: 0) {
                    Spacer()
                    Button { progress = max(0, progress - 0.1) } label: {
                        Image(systemName: "backward.fill").font(.title2)
                    }
                    .buttonStyle(.plain).foregroundStyle(.primary)
                    Spacer()
                    Button { isPlaying.toggle() } label: {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 58))
                    }
                    .buttonStyle(.plain).foregroundStyle(.blue)
                    Spacer()
                    Button { progress = min(1, progress + 0.1) } label: {
                        Image(systemName: "forward.fill").font(.title2)
                    }
                    .buttonStyle(.plain).foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.vertical, 8)
            }

            
            Section("Громкость") {
                HStack(spacing: 10) {
                    Image(systemName: "speaker.fill").foregroundStyle(.secondary).frame(width: 20)
                    Slider(value: $volume).tint(.blue)
                    Image(systemName: "speaker.wave.3.fill").foregroundStyle(.secondary).frame(width: 24)
                }
            }

            Section("Статус") {
                LabeledContent("Трек", value: "Эльбрус Джанмирзоев - Чародейка")
                LabeledContent("Воспроизведение", value: isPlaying ? "Да" : "Нет")
                LabeledContent("Прогресс", value: "\(Int(progress * 100))%")
            }
        }
        .navigationTitle("Плеер")
        // Прогресс ползёт автоматически когда isPlaying = true
        .onChange(of: isPlaying) { _, playing in
            guard playing else { return }
            Task {
                while isPlaying && progress < 1.0 {
                    try? await Task.sleep(nanoseconds: 50_000_000)
                }
                if progress >= 1.0 { isPlaying = false; progress = 0 }
            }
        }
    }
}

// MARK: - 2.5. Thread — расчёт среднего пар в день

struct ThreadDemoView: View {
    @State private var totalPairs = ""
    @State private var studyDays = ""
    @State private var result: String? = nil
    @State private var loading = false

    var body: some View {
        List {
            Section("Исходные данные") {
                HStack {
                    Text("Всего пар")
                    Spacer()
                    TextField("например, 60", text: $totalPairs)
                        .keyboardType(.numberPad).multilineTextAlignment(.trailing).foregroundStyle(.blue)
                }
                HStack {
                    Text("Учебных дней")
                    Spacer()
                    TextField("например, 20", text: $studyDays)
                        .keyboardType(.numberPad).multilineTextAlignment(.trailing).foregroundStyle(.blue)
                }
            }

            Section {
                Button {
                    guard let p = Int(totalPairs), let d = Int(studyDays), d > 0 else { return }
                    loading = true; result = nil
                    Task.detached(priority: .background) {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        let avg = String(format: "%.1f", Double(p) / Double(d))
                        await MainActor.run { result = avg; loading = false }
                    }
                } label: {
                    HStack {
                        Text("Рассчитать в фоновом потоке")
                        Spacer()
                        if loading { ProgressView() }
                    }
                }
                .disabled(loading || totalPairs.isEmpty || studyDays.isEmpty)
            }

            if let result {
                Section("Результат") {
                    LabeledContent("Среднее пар в день", value: result)
                }
            }

            Section("Как это работает") {
                Text("Task.detached(priority: .background) = новый фоновый поток (аналог new Thread(...).start()). После вычисления — MainActor.run = возврат в UI-поток (аналог runOnUiThread).")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Thread")
    }
}

// MARK: - 3.1. Thread in UI — runOnUiThread / postDelayed

struct ThreadUIView: View {
    @State private var log: [LogEntry] = []
    @State private var running = false

    struct LogEntry: Identifiable {
        let id = UUID(); let time: String; let method: String; let message: String
    }

    var body: some View {
        List {
            Section {
                Button {
                    log = []; running = true
                    Task {
                        append("runOnUiThread", "runnable1 — немедленно")
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        append("postDelayed(2000)", "runnable3 — через 2 сек")
                        append("post", "runnable2 — после delay")
                        running = false
                    }
                } label: {
                    HStack {
                        Text("Запустить последовательность")
                        Spacer()
                        if running { ProgressView() }
                    }
                }
                .disabled(running)
            }

            if !log.isEmpty {
                Section("Лог") {
                    ForEach(log) { e in
                        HStack(alignment: .top, spacing: 10) {
                            Text(e.time).font(.caption.monospaced()).foregroundStyle(.secondary).frame(width: 70)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(e.method).font(.caption).foregroundStyle(.blue)
                                Text(e.message).font(.caption)
                            }
                        }
                    }
                }
            }

            Section("Android → iOS") {
                LabeledContent("runOnUiThread", value: "MainActor.run { }")
                LabeledContent("View.post", value: "Task { }")
                LabeledContent("postDelayed(r, 2000)", value: "Task.sleep(2s) + MainActor")
            }
        }
        .navigationTitle("Thread in UI")
    }

    func append(_ method: String, _ msg: String) {
        let f = DateFormatter(); f.dateFormat = "HH:mm:ss"
        log.append(LogEntry(time: f.string(from: Date()), method: method, message: msg))
    }
}

// MARK: - 3.2. Looper — Handler + MessageQueue

struct LooperDemoView: View {
    @State private var age = ""
    @State private var job = ""
    @State private var queueLog: [String] = []
    @State private var processing = false

    var body: some View {
        List {
            Section("Сообщение (Bundle)") {
                HStack {
                    Text("Возраст")
                    Spacer()
                    TextField("число", text: $age).keyboardType(.numberPad).multilineTextAlignment(.trailing).foregroundStyle(.blue)
                }
                HStack {
                    Text("Профессия (KEY)")
                    Spacer()
                    TextField("developer", text: $job).multilineTextAlignment(.trailing).foregroundStyle(.blue)
                }
            }

            Section {
                Button {
                    guard let a = Int(age), !job.isEmpty else { return }
                    queueLog = ["→ sendMessage: KEY=\"\(job)\" → MessageQueue"]
                    processing = true
                    Task.detached {
                        try? await Task.sleep(nanoseconds: UInt64(a) * 1_000_000_000)
                        await MainActor.run {
                            queueLog.append("← handleMessage: кол-во букв в «\(job)» = \(job.count)")
                            processing = false
                        }
                    }
                } label: {
                    HStack {
                        Text("Отправить в MessageQueue")
                        Spacer()
                        if processing { ProgressView() }
                    }
                }
                .disabled(processing || age.isEmpty || job.isEmpty)
            }

            if !queueLog.isEmpty {
                Section("Лог очереди") {
                    ForEach(queueLog, id: \.self) {
                        Text($0).font(.caption.monospaced()).foregroundStyle(.secondary)
                    }
                }
            }

            Section("Как это работает") {
                Text("Looper — бесконечный цикл, ожидающий сообщений. Задержка = возраст (сек) симулирует время обработки. Handler.handleMessage получает данные и возвращает результат в UI-поток.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Looper")
    }
}

// MARK: - 3.3. CryptoLoader — AES-GCM шифрование и дешифровка

struct CryptoLoaderView: View {
    @State private var input = ""
    @State private var encrypted = ""
    @State private var decrypted = ""
    @State private var loading = false

    var body: some View {
        List {
            Section("Ввод") {
                HStack {
                    Text("Фраза")
                    Spacer()
                    TextField("введите текст", text: $input).multilineTextAlignment(.trailing).foregroundStyle(.blue)
                }
            }

            Section {
                Button {
                    let text = input; loading = true; encrypted = ""; decrypted = ""
                    Task.detached(priority: .background) {
                        let key = SymmetricKey(size: .bits256)
                        do {
                            let sealed = try AES.GCM.seal(Data(text.utf8), using: key)
                            let hex = sealed.ciphertext.prefix(8).map { String(format: "%02x", $0) }.joined()
                            try await Task.sleep(nanoseconds: 1_000_000_000)
                            let plain = try AES.GCM.open(sealed, using: key)
                            await MainActor.run {
                                encrypted = hex + "..."
                                decrypted = String(data: plain, encoding: .utf8) ?? "?"
                                loading = false
                            }
                        } catch {
                            await MainActor.run { decrypted = "Ошибка"; loading = false }
                        }
                    }
                } label: {
                    HStack {
                        Text("Зашифровать → Loader → Расшифровать")
                        Spacer()
                        if loading { ProgressView() }
                    }
                }
                .disabled(loading || input.isEmpty)
            }

            if !encrypted.isEmpty {
                Section("Результат") {
                    LabeledContent("Алгоритм", value: "AES-256-GCM")
                    LabeledContent("Cipher (hex)", value: encrypted)
                    LabeledContent("Расшифровано", value: decrypted)
                }
            }

            Section("Как это работает") {
                Text("Аналог AsyncTaskLoader: шифрование и расшифровка в фоновом потоке. SymmetricKey(256 бит) = аналог generateKey() + SecretKeySpec. Ключ живёт только в этой сессии.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("CryptoLoader")
    }
}

// MARK: - 4. Service — Аудиоплеер (PlayerService)

@Observable
class AudioService {
    var isPlaying = false
    var trackName = "Эльбрус Джанмирзоев - Бродяга"
    var status = "Готов"

    func play()  { isPlaying = true;  status = "Воспроизводится" }
    func stop()  { isPlaying = false; status = "Остановлено"    }
}

struct ServicePlayerView: View {
    @State private var service = AudioService()
    @State private var progress: Double = 0.0

    func timeLabel(_ ratio: Double) -> String {
        let s = Int(ratio * 180)
        return String(format: "%d:%02d", s / 60, s % 60)
    }

    var body: some View {
        List {
            // Обложка
            Section {
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.purple.opacity(0.1))
                            .frame(width: 180, height: 180)
                        Image(systemName: service.isPlaying ? "waveform" : "music.note.house")
                            .font(.system(size: 64, weight: .light))
                            .foregroundStyle(.purple)
                            .symbolEffect(.pulse, isActive: service.isPlaying)
                    }
                    VStack(spacing: 4) {
                        Text("Лучшая Песня").font(.title3.bold())
                        Text("Студент МИРЭА").font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
            }

            // Прогресс
            Section {
                VStack(spacing: 4) {
                    Slider(value: $progress).tint(.purple)
                    HStack {
                        Text(timeLabel(progress)).font(.caption2).foregroundStyle(.secondary)
                        Spacer()
                        Text("-\(timeLabel(1 - progress))").font(.caption2).foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 2)

                HStack(spacing: 0) {
                    Spacer()
                    Button { progress = max(0, progress - 0.1) } label: {
                        Image(systemName: "backward.fill").font(.title2)
                    }.buttonStyle(.plain).foregroundStyle(.primary)
                    Spacer()
                    Button {
                        if service.isPlaying { service.stop() } else { service.play() }
                    } label: {
                        Image(systemName: service.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 58))
                    }.buttonStyle(.plain).foregroundStyle(.purple)
                    Spacer()
                    Button { progress = min(1, progress + 0.1) } label: {
                        Image(systemName: "forward.fill").font(.title2)
                    }.buttonStyle(.plain).foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.vertical, 8)
            }

            Section("Статус сервиса") {
                LabeledContent("Трек", value: service.trackName)
                LabeledContent("Состояние", value: service.status)
            }

            Section("Как это работает") {
                Text("AudioService — аналог PlayerService extends Service. @Observable автоматически обновляет UI при изменении свойств (аналог LiveData). Сервис живёт независимо от экрана.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Service")
        .onChange(of: service.isPlaying) { _, playing in
            guard playing else { return }
            Task {
                while service.isPlaying && progress < 1.0 {
                    try? await Task.sleep(nanoseconds: 50_000_000)
                    progress = min(progress + 0.0003, 1.0)
                }
                if progress >= 1.0 { service.stop(); progress = 0 }
            }
        }
    }
}

// MARK: - 5. WorkManager — фоновая задача с реальными Constraints

struct WorkManagerView: View {
    enum WorkStatus: String {
        case idle = "Ожидание", enqueued = "В очереди", running = "Выполняется", finished = "Завершено"
    }

    @State private var networkAvailable = true
    @State private var chargingAvailable = false

    @State private var status: WorkStatus = .idle
    @State private var progress: Double = 0

  
    var constraintsMet: Bool { networkAvailable }

    var statusColor: Color {
        switch status {
        case .idle: .secondary; case .enqueued: .orange; case .running: .blue; case .finished: .green
        }
    }

    var body: some View {
        List {

            Section {
                Toggle(isOn: $networkAvailable) {
                    Label("Сеть доступна", systemImage: "wifi")
                }
            } header: {
                Text("Симуляция окружения")
            } footer: {
                Text("Переключите «Сеть» в OFF — кнопка запуска заблокируется, т.к. Worker требует интернет.")
            }

            if !constraintsMet {
                Section {
                    Label("Нет сети — Worker ждёт в очереди", systemImage: "wifi.slash")
                        .foregroundStyle(.orange)
                }
            }

            Section("WorkRequest") {
                LabeledContent("Тип", value: "OneTimeWorkRequest")
                LabeledContent("Worker", value: "UploadWorker")
                LabeledContent("Constraint", value: "NetworkType.CONNECTED")
                LabeledContent("Статус") {
                    Text(status.rawValue).foregroundStyle(statusColor)
                }
            }

            if status == .running {
                Section("Прогресс doWork()") {
                    VStack(spacing: 4) {
                        ProgressView(value: progress).tint(.blue)
                        HStack {
                            Text("0%").font(.caption2).foregroundStyle(.secondary)
                            Spacer()
                            Text("\(Int(progress * 100))%").font(.caption2).foregroundStyle(.blue)
                            Spacer()
                            Text("100%").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }

            Section {
                Button {
                    enqueue()
                } label: {
                    HStack {
                        Text(status == .finished ? "Запустить снова" : "Enqueue Worker")
                        Spacer()
                        if status == .running { ProgressView() }
                    }
                }
                .disabled(!constraintsMet || status == .running || status == .enqueued)
            }

            Section("Как это работает") {
                Text("WorkManager не запустит задачу, пока не выполнены Constraints. Здесь Workers требует сеть — toggle «Сеть» симулирует это. Реально система сама проверяет NetworkCapabilities.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("WorkManager")
    }

    func enqueue() {
        status = .enqueued; progress = 0
        Task.detached(priority: .background) {
            await MainActor.run { status = .running }
            for i in 1...10 {
                try? await Task.sleep(nanoseconds: 300_000_000)
                await MainActor.run { progress = Double(i) / 10 }
            }
            await MainActor.run { status = .finished }
        }
    }
}

// MARK: - Главное меню

struct Lesson4View: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Привязка компонентов") {
                    navRow("1. ViewBinding", sub: "Музыкальный плеер с binding", icon: "music.note", color: .purple, dest: MusicPlayerView())
                }
                Section("Асинхронность и потоки") {
                    navRow("2.5. Thread", sub: "Расчёт в фоновом потоке", icon: "cpu", color: .blue, dest: ThreadDemoView())
                    navRow("3.1. Thread in UI", sub: "runOnUiThread, post, postDelayed", icon: "arrow.triangle.2.circlepath", color: .teal, dest: ThreadUIView())
                    navRow("3.2. Looper", sub: "Handler + MessageQueue", icon: "arrow.circlepath", color: .green, dest: LooperDemoView())
                    navRow("3.3. CryptoLoader", sub: "AES через AsyncTaskLoader", icon: "lock.shield", color: .red, dest: CryptoLoaderView())
                }
                Section("Фоновые компоненты") {
                    navRow("4. Service", sub: "Аудиосервис PlayerService", icon: "speaker.wave.2", color: .orange, dest: ServicePlayerView())
                    navRow("5. WorkManager", sub: "OneTimeWorkRequest + Constraints", icon: "gear.circle", color: .indigo, dest: WorkManagerView())
                }
            }
            .navigationTitle("Практика 4")
        }
    }

    @ViewBuilder
    func navRow<D: View>(_ title: String, sub: String, icon: String, color: Color, dest: D) -> some View {
        NavigationLink(destination: dest) {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    Text(sub).font(.caption).foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: icon).foregroundStyle(color)
            }
        }
    }
}

#Preview("Главное меню") { Lesson4View() }
#Preview("Плеер") { NavigationStack { MusicPlayerView() } }
#Preview("Thread") { NavigationStack { ThreadDemoView() } }
#Preview("Thread UI") { NavigationStack { ThreadUIView() } }
#Preview("Looper") { NavigationStack { LooperDemoView() } }
#Preview("CryptoLoader") { NavigationStack { CryptoLoaderView() } }
#Preview("Сервис") { NavigationStack { ServicePlayerView() } }
#Preview("WorkManager") { NavigationStack { WorkManagerView() } }
