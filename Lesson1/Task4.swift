//
//  Task4.swift
//  PracticeOne
//
//  Created by Даниил Лоллин on 25.02.2026.
//

import SwiftUI
struct ContactCardView: View {
    var body: some View{
        VStack{
            Image("danek")
                .resizable()
                .frame(width: 250, height: 250)
                .cornerRadius(50)
            HStack{
                Text("Name:")
                    .font(.title)
                Text("Daniil Lollin")
                    .font(.title)
            }
            HStack{
                Text("Organisation:")
                    .font(.title)
                Text("MIREA")
                    .font(.title)
            }
            HStack{
                Image(systemName: "phone")
                    .font(.title)
                Text("+7 (915) 763-07-71")
                    .font(.title)
                
            }
            Button("Save"){}
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(50)
        }
        
    }
}

#Preview {
    ContactCardView()
}
