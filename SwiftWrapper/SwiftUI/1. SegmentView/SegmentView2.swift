//
//  SegmentView.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

//
//
//import SwiftUI
//
//// MARK: - PopPang Segment
//struct PopPangSegment: View {
//    @Binding var selected: Int
//    let titles: [String]
//
//    var body: some View {
//        VStack(spacing: 6) {
//            HStack(spacing: 0) {
//                ForEach(titles.indices, id: \.self) { index in
//                    Button {
//                        withAnimation(.easeInOut) {
//                            selected = index
//                        }
//                    } label: {
//                        Text(titles[index])
//                            .font(.system(size: 15, weight: selected == index ? .bold : .regular))
//                            .foregroundStyle(selected == index ? .primary : .secondary)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                    }
//                    .buttonStyle(.plain)
//                }
//            }
//
//            GeometryReader { geo in
//                let width = geo.size.width / CGFloat(titles.count)
//
//                ZStack(alignment: .leading) {
//                    Capsule()
//                        .fill(.secondary.opacity(0.25))
//                        .frame(height: 3)
//
//                    Capsule()
//                        .fill(.primary)
//                        .frame(width: width)
//                        .offset(x: width * CGFloat(selected))
//                        .animation(.easeInOut, value: selected)
//                }
//            }
//            .frame(height: 3)
//        }
//        .padding(.horizontal)
//        .background(.ultraThinMaterial)
//    }
//}
//
//// MARK: - A View
//struct AView: View {
//    let isEnabled: Bool
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 12) {
//                ForEach(0..<20) { i in
//                    Text("A View - Item \(i)")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(.blue.opacity(0.2))
//                        .cornerRadius(8)
//                }
//            }
//            .padding()
//        }
//        .scrollDisabled(!isEnabled)
//    }
//}
//
//// MARK: - B View
//struct BView: View {
//    let isEnabled: Bool
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 12) {
//                ForEach(0..<20) { i in
//                    Text("B View - Item \(i)")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(.green.opacity(0.2))
//                        .cornerRadius(8)
//                }
//            }
//            .padding()
//        }
//        .scrollDisabled(!isEnabled)
//    }
//}
//
//// MARK: - Main View
//struct SegmentView2: View {
//
//    @State private var selectedIndex = 0
//    @State private var enableChildScroll = false
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 0) {
//
//                // Header
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(height: 120)
//                    .overlay(
//                        Text("Header Area")
//                            .font(.title2.bold())
//                            .foregroundStyle(.white)
//                    )
//
//                // Sticky Segment
//                PopPangSegment(
//                    selected: $selectedIndex,
//                    titles: ["A", "B"]
//                )
//
//                // Horizontal Paging
//                TabView(selection: $selectedIndex) {
//                    AView(isEnabled: enableChildScroll)
//                        .tag(0)
//
//                    BView(isEnabled: enableChildScroll)
//                        .tag(1)
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                .frame(height: UIScreen.main.bounds.height - 250)
//            }
//        }
//        .scrollDisabled(enableChildScroll)
//        .gesture(
//            DragGesture()
//                .onChanged { _ in
//                    enableChildScroll = true
//                }
//        )
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    SegmentView2()
//}







//
//
//import SwiftUI
//
//// MARK: - Segment
//struct PopPangSegment: View {
//    @Binding var selected: Int
//
//    var body: some View {
//        VStack(spacing: 6) {
//            HStack {
//                ForEach(["A", "B", "C"].indices, id: \.self) { i in
//                    Button {
//                        withAnimation {
//                            selected = i
//                        }
//                    } label: {
//                        Text(["A", "B", "C"][i])
//                            .font(.system(size: 15, weight: selected == i ? .bold : .regular))
//                            .foregroundStyle(selected == i ? .primary : .secondary)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 10)
//                    }
//                }
//            }
//
//            GeometryReader { geo in
//                Capsule()
//                    .fill(.primary)
//                    .frame(width: geo.size.width / 3)
//                    .offset(x: geo.size.width / 3 * CGFloat(selected))
//                    .animation(.easeInOut, value: selected)
//            }
//            .frame(height: 3)
//        }
//        .background(.ultraThinMaterial)
//    }
//}
//
//// MARK: - Page Contents (NO ScrollView)
//struct AView: View {
//    var body: some View {
//        LazyVStack(spacing: 12) {
//            ForEach(0..<5) {
//                Text("A Item \($0)")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue.opacity(0.2))
//                    .cornerRadius(12)
//            }
//        }
//    }
//}
//
//struct BView: View {
//    var body: some View {
//        LazyVStack(spacing: 12) {
//            ForEach(0..<30) {
//                Text("B Item \($0)")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.green.opacity(0.2))
//                    .cornerRadius(12)
//            }
//        }
//    }
//}
//
//struct CView: View {
//    var body: some View {
//        LazyVStack(spacing: 12) {
//            ForEach(0..<8) {
//                Text("C Item \($0)")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.orange.opacity(0.2))
//                    .cornerRadius(12)
//            }
//        }
//    }
//}
//
//// MARK: - Main View
//struct SegmentView2: View {
//
//    @State private var selected = 0
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//
//                // Header
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(height: 120)
//                    .overlay(
//                        Text("Header Area")
//                            .font(.title2.bold())
//                            .foregroundStyle(.white)
//                    )
//
//                // Sticky Segment
//                Section(
//                    header: PopPangSegment(selected: $selected)
//                ) {
//                    Group {
//                        switch selected {
//                        case 0:
//                            AView()
//                        case 1:
//                            BView()
//                        default:
//                            CView()
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    SegmentView2()
//}



import SwiftUI

// MARK: - Segment Header
struct PopPangSegment: View {
    let titles: [String]
    @Binding var selected: Int

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                ForEach(titles.indices, id: \.self) { i in
                    Button {
                        withAnimation {
                            selected = i
                        }
                    } label: {
                        Text(titles[i])
                            .font(.system(size: 15, weight: selected == i ? .bold : .regular))
                            .foregroundStyle(selected == i ? .primary : .secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                }
            }

            GeometryReader { geo in
                Capsule()
                    .fill(.primary)
                    .frame(width: geo.size.width / CGFloat(titles.count))
                    .offset(x: geo.size.width / CGFloat(titles.count) * CGFloat(selected))
                    .animation(.easeInOut, value: selected)
            }
            .frame(height: 3)
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - Reusable Segment Container
struct SegmentContainer: View {

    let titles: [String]
    let pages: [AnyView]

    @State private var selected = 0

    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {

                // Header
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 120)
                    .overlay(
                        Text("Header Area")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    )

                // Sticky Segment
                Section(
                    header: PopPangSegment(
                        titles: titles,
                        selected: $selected
                    )
                ) {
                    pages[selected]
                }
            }
        }
    }
}

// MARK: - Page Contents (NO ScrollView)
struct AView: View {
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(0..<5) {
                Text("A Item \($0)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
            }
        }
    }
}

struct BView: View {
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(0..<30) {
                Text("B Item \($0)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(12)
            }
        }
    }
}

struct CView: View {
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(0..<8) {
                Text("C Item \($0)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(12)
            }
        }
    }
}

struct SegmentView2: View {
    var body: some View {
        SegmentContainer(
            titles: ["A", "B", "C"],
            pages: [
                AnyView(AView()),
                AnyView(BView()),
                AnyView(CView())
            ]
        )
    }
}

#Preview {
    SegmentView2()
}

