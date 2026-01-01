//
//  TestView.swift
//  SwiftWrapper
//
//  Created by 김동현 on 1/1/26.
//

import SwiftUI

// MARK: - Test View
struct ProfileView: View {
    @State private var name = "John"
    @State private var count = 0

    var body: some View {
        VStack(spacing: 20) {
            Text(name)
                .font(.title)
                .debugViewUpdates("ProfileName")

            ExpensiveView(count: count)
                .debugViewUpdates("ExpensiveComponent")

            Button("Update Name") {
                name = ["John", "Steve", "Emily", "Alice"].randomElement()!
            }

            Button("Trigger Expensive Update") {
                count += 1
            }
        }
        .padding()
    }
}

// MARK: - Expensive View (비싼 연산을 가정)
struct ExpensiveView: View {
    let count: Int

    var body: some View {
        VStack {
            Text("Heavy View")
                .font(.headline)

            Text("Count: \(count)")
        }
        .padding()
        .background(Color.blue.opacity(0.15))
        .cornerRadius(8)
    }
}

// MARK: - Debug Modifier
extension View {
    func debugViewUpdates(_ label: String = "") -> some View {
        self
            .background(
                Color.random
                    .opacity(0.3)
                    .animation(.easeInOut(duration: 0.25), value: UUID())
            )
            .onAppear {
                print("🔄 View appeared: \(label)")
            }
            .onChange(of: UUID()) { _, _ in
                print("🔁 View updated: \(label)")
            }
    }
}

// MARK: - Random Color Helper
extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0.3...1),
            green: .random(in: 0.3...1),
            blue: .random(in: 0.3...1)
        )
    }
}

// MARK: - Preview
#Preview {
    ProfileView()
}
