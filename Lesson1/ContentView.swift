//
//  ContentView.swift
//  PracticeOne
//
//  Created by Даниил Лоллин on 25.02.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Task1") {
                    LinearLayoutView()
                }
                NavigationLink("Task2") {
                    TableLayoutView()
                }
                NavigationLink("Task3") {
                    ConstraintLayoutView()
                }
                NavigationLink("Task4") {
                    ContactCardView()
                }
                NavigationLink("Task5") {
                    OrientationView()
                }
                NavigationLink("Task6") {
                    FindViewView()
                }
                NavigationLink("Task7") {
                    ButtonClickerView()
                }
            }
            .navigationTitle("Practice One")
        }
    }
}

#Preview {
    ContentView()
}



