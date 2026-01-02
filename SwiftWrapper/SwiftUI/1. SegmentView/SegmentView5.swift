////
////  SegmentView4.swift
////  SwiftWrapper
////
////  Created by 김동현 on 1/2/26.
////
//
//import SwiftUI
//
//private struct TestAView: View {
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                ForEach(0..<30) { _ in
//                    Text("AView")
//                }
//            }
//        }
//    }
//}
//
//
//private struct TestBView: View {
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                ForEach(0..<50) { _ in
//                    Text("BView")
//                }
//            }
//        }
//    }
//}
//
//struct SegmentView5: View {
//    var body: some View {
//        VStack {
//            
//        }
//    }
//}
//
//
//
//#Preview {
//    SegmentView5()
//}
//
import SwiftUI

struct SegmentView5: View {

    @State private var selectedIndex = 0

    private let titles = ["홈", "인기", "저장"]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // 상단 영역
                VStack(alignment: .leading, spacing: 12) {
                    Text("상단 콘텐츠 영역")
                        .font(.title)
                        .bold()

                    Text("이 영역은 스크롤됩니다.")
                        .foregroundColor(.gray)
                }
                .padding()

                // 세그먼트
                SegmentControl(
                    titles: titles,
                    selectedIndex: $selectedIndex
                )
                .padding(.vertical, 12)

                // 콘텐츠 영역
                TabView(selection: $selectedIndex) {
                    TestAView().tag(0)
                    TestBView().tag(1)
                    TestCView().tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct TestAView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<80) { index in
                Text("🔥 A 콘텐츠 \(index)")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

private struct TestBView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<10) { index in
                Text("✨ B 콘텐츠 \(index)")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

private struct TestCView: View {
    var body: some View {
        VStack {
            Text("C 탭")
                .font(.title)
                .padding()
        }
    }
}
