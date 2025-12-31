//
//  SegmentView.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import SwiftUI

struct SegmentView3: View {
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                
                // 고정될 영역
                Section {
                    ForEach(0..<20) { _ in
                        Text("스크롤되는 내용")
                            .padding()
                    }
                } header: {
                    HStack {
                        Text("섹션")
                            .font(.headline)
                            .padding()
                            .zIndex(1)
                        Spacer()
                    }
                    .background(Color.white)
                }
            }
        }
    }
}

#Preview {
    SegmentView3()
}
