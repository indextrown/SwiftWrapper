//
//  SwiftUIListView.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import SwiftUI

struct SwiftUIListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("섹션1") {
                    NavigationLink("샘플1") {
                        SegmentView()
                    }
                }
            }
        }
    }
}

#Preview {
    SwiftUIListView()
}
