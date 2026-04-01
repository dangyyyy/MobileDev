import SwiftUI

// MARK: - Time Picker
struct TimePickerView: View {
    @State private var time = Date()
    @Environment(\.dismiss) var dismiss
    
    var onSelect: (Date) -> Void
    
    var body: some View {
        VStack {
            Text("Выберите время")
                .font(.headline)
                .padding()
            
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
            
            Button("ОК") {
                onSelect(time)
                dismiss()
            }
            .padding()
        }
    }
}
