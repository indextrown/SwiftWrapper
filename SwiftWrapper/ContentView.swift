//
//  ContentView.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab: Int = 2
    @State private var tabBarHeight: CGFloat = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SwiftUIListView()
                .tabItem {
                    Label("SwiftUI", systemImage: "1.square.fill")
                }
                .tag(1)
            
            UIKitListViewController.getRepresentablee()
                .tabItem {
                    Label("UIKit", systemImage: "2.square.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
