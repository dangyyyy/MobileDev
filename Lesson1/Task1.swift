//
//  Task1.swift
//  PracticeOne
//
//  Created by Даниил Лоллин on 25.02.2026.
//

import SwiftUI

struct LinearLayoutView: View {
    var body: some View{
        VStack {
            HStack {
                Button("Button 1") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                Button("Button 2") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                Button("Button 3") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
            }
            HStack {
                Button("Button 4") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                Button("Button 5") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                Button("Button 6") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
            }
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    LinearLayoutView()
}
