//
//  Task6.swift
//  PracticeOne
//
//  Created by Даниил Лоллин on 25.02.2026.
//

import SwiftUI

struct FindViewView: View {
    
    @State private var labelText = "Hello World!"
    @State private var isChecked = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(labelText)
            HStack{
                Text("Чекбокс")
                Toggle("", isOn: $isChecked)
                    .labelsHidden()
                    
            }
            
            Button("Изменить текст") {
                labelText = "Новый текст"
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(50)
            
            Button("Поставить галочку") {
                isChecked = !isChecked
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(50)
        }
        .padding()
    }
}

#Preview {
    FindViewView()
}

