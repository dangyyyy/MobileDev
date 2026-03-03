//
//  Task7.swift
//  PracticeOne
//
//  Created by Даниил Лоллин on 25.02.2026.
//

import SwiftUI

struct ButtonClickerView: View {
    @State private var text = "Нажми кнопку"

    var body: some View {
        VStack {
            Text(text)
                .font(.title)

            Button("Who Am I?") {
                text = "Мой номер по списку №5"
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(50)

            Button("It's Not Me") {
                text = "Это не я сделал"
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(50)
        }
    }
}


#Preview {
    ButtonClickerView()
}
