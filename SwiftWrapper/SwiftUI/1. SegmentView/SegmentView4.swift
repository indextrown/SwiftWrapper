//
//  SegmentView4.swift
//  SwiftWrapper
//
//  Created by 김동현 on 1/2/26.
//

import SwiftUI

private struct TestAView: View {
    
    var body: some View {
        VStack {
            ForEach(0..<50) { _ in
                Text("AView 내용")
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.yellow)
    }
}

private struct TestBView: View {
    
    var body: some View {
        VStack {
            ForEach(0..<30) { _ in
                Text("BView 내용")
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.green)
    }
}


struct SegmentControl: View {
    
    let titles: [String]
    @Binding var selectedIndex: Int
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 6) {

            // 버튼 영역
            HStack(spacing: 0) {
                ForEach(titles.indices, id: \.self) { index in
                    Button {
                        withAnimation(.easeInOut) {
                            selectedIndex = index
                        }
                    } label: {
                        Text(titles[index])
                            .font(.system(size: 15, weight: selectedIndex == index ? .bold : .regular))
                            .foregroundColor(selectedIndex == index ? .black : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                }
            }

            // 하단 인디케이터
            GeometryReader { geo in
                let width = geo.size.width / CGFloat(titles.count)

                Capsule()
                    .fill(Color.black)
                    .frame(width: width, height: 3)
                    .offset(x: CGFloat(selectedIndex) * width)
                    .animation(.easeInOut(duration: 0.25), value: selectedIndex)
            }
            .frame(height: 3)
        }
        
    }
}


struct SegmentView4: View {

    @State private var selectedIndex = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var pageHeights: [Int: CGFloat] = [:]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // 상단 고정 영역
                Rectangle()
                    .frame(height: 200)
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {
                    Text("제목")
                    Text("날짜")
                    Text("운영시간")
                }
                .padding(.horizontal)

                // 세그먼트
                SegmentControl(
                    titles: ["정보", "내용"],
                    selectedIndex: $selectedIndex
                )
                
                ZStack(alignment: .top) {

                    TestAView()
                        .measureHeight(index: 0)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .offset(x: selectedIndex == 0 ? dragOffset : -UIScreen.main.bounds.width + dragOffset)
                    

                    TestBView()
                        .measureHeight(index: 1)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .offset(x: selectedIndex == 1 ? dragOffset : UIScreen.main.bounds.width + dragOffset)
                }
                .contentShape(Rectangle())
                .frame(height: pageHeights[selectedIndex] ?? 0, alignment: .top)
                .clipped() // ⭐️ 이게 핵심
                .animation(.easeOut(duration: 0.25), value: selectedIndex)
                
                .simultaneousGesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            // 가로 제스처만 처리
                            guard abs(value.translation.width) > abs(value.translation.height) else { return }

                            let isAtFirst = selectedIndex == 0
                            let isAtLast = selectedIndex == 1 // 현재 페이지 수가 2개라서

                            let isSwipingRight = value.translation.width > 0
                            let isSwipingLeft = value.translation.width < 0

                            // 🚫 경계에서 막기
                            if (isAtFirst && isSwipingRight) || (isAtLast && isSwipingLeft) {
                                return
                            }

                            state = value.translation.width
                        }
                        .onEnded { value in
                            let horizontal = value.translation.width
                            let vertical = value.translation.height

                            guard abs(horizontal) > abs(vertical) else { return }

                            let threshold = UIScreen.main.bounds.width * 0.25

                            if horizontal < -threshold {
                                selectedIndex = min(selectedIndex + 1, 1)
                            } else if horizontal > threshold {
                                selectedIndex = max(selectedIndex - 1, 0)
                            }
                        }
                )



                .onPreferenceChange(PageHeightKey.self) { heights in
                    pageHeights = heights
                }


            }
        }
        .ignoresSafeArea(edges: .vertical)
    }
}

/// .contentShape(Rectangle())
/// SwiftUI는 기본적으로👉 보이는 영역만 hit-test 함
/// VStack 안에 Text만 있으면빈 공간은 터치 안 됨 ❌
/// 빈 영역 포함해서 전체 영역이 터치 가능



#Preview {
    SegmentView4()
}

struct PageHeightKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]

    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

extension View {
    func measureHeight(index: Int) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: PageHeightKey.self,
                                value: [index: geo.size.height])
            }
        )
    }
}

