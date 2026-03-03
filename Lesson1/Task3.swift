//
//  Task3.swift
//  PracticeOne
//
//  Created by Даниил Лоллин on 25.02.2026.
//

import SwiftUI

struct ConstraintLayoutView: View {
    var body: some View{
        VStack {
            Text("Я сверху")
            Spacer()
            Text("Я посередине")
            Spacer()
            Button("Я снизу"){}
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(50)
        }
        .padding()
    }
}

#Preview {
    ConstraintLayoutView()
}

