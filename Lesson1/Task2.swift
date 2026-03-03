//
//  Task2.swift
//  PracticeOne
//
//  Created by Даниил Лоллин on 25.02.2026.
//

import SwiftUI

struct TableLayoutView: View {
    var body: some View{
        VStack(spacing: 15) { // расстояние между строками
            HStack {
                Button("Button 1") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("This is table view")
                    .frame(maxWidth: .infinity, alignment: .center)

                Button("Button 2") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            HStack{
                Button("Button 3") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("CheckBox")
                    .frame(maxWidth: .infinity, alignment: .center)

                Toggle("", isOn: .constant(false))
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            HStack {
                Button(action: {}) {
                    Image(systemName: "power")
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(50)
                .frame(maxWidth: .infinity, alignment: .center)

                Button("Button 5"){}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .frame(maxWidth: .infinity, alignment: .center)

                Button("Button 6"){}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    TableLayoutView()
}
