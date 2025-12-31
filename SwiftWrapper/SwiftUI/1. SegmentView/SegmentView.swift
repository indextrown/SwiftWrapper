//
//  SegmentView.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import SwiftUI
//
//struct SegmentView: View {
//    var body: some View {
//        VStack {
//            List {
//                Section {
//                    Text("컨텐츠1")
//                } header: {
//                    Text("섹션1")
//                        .padding(.vertical, 8)
//                        .background(.ultraThinMaterial)
//                    
//                }
//            }
//            .listStyle(.plain)
//        }
//    }
//}


//import SwiftUI
//
//struct SegmentView: View {
//    var body: some View {
//        ScrollView {
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//
//                Section {
//                    ForEach(0..<20) { i in
//                        Text("아이템 \(i)")
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .leading)
////                            .background(Color(.systemGray6))
//                    }
//                } header: {
//                    Text("섹션 1")
//                        .font(.headline)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(.ultraThinMaterial) // ⭐ 핵심
//                }
//
//            }
//        }
//    }
//}

//import SwiftUI
//
//struct SegmentView: View {
//    @State private var selectedTab: Int = 0
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//
//                Section {
//
//                    // 🔽 세그먼트에 따라 다른 뷰
//                    if selectedTab == 0 {
//                        AView()
//                    } else {
//                        BView()
//                    }
//
//                } header: {
//                    Picker("", selection: $selectedTab) {
//                        Text("A").tag(0)
//                        Text("B").tag(1)
//                    }
//                    .pickerStyle(.segmented)
//                    .padding()
//                    .background(.ultraThinMaterial) // sticky 시 배경
//                }
//            }
//        }
//    }
//}
//

//
//struct ViewHeightKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = max(value, nextValue())
//    }
//}
//
//extension View {
//    func readHeight(_ onChange: @escaping (CGFloat) -> Void) -> some View {
//        background(
//            GeometryReader { geo in
//                Color.clear
//                    .preference(key: ViewHeightKey.self,
//                                value: geo.size.height)
//            }
//        )
//        .onPreferenceChange(ViewHeightKey.self, perform: onChange)
//    }
//}
//
//struct SegmentView: View {
//    @State private var selectedTab = 0
//    @State private var contentHeight: CGFloat = 300
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//
//                Section {
//                    TabView(selection: $selectedTab) {
//
//                        AView()
//                            .readHeight { height in
//                                if selectedTab == 0 {
//                                    contentHeight = height
//                                }
//                            }
//                            .tag(0)
//
//                        BView()
//                            .readHeight { height in
//                                if selectedTab == 1 {
//                                    contentHeight = height
//                                }
//                            }
//                            .tag(1)
//                    }
//                    .tabViewStyle(.page(indexDisplayMode: .never))
//                    .frame(height: contentHeight) // ⭐ 핵심
//                    .animation(.easeInOut, value: contentHeight)
//
//                } header: {
//                    Picker("", selection: $selectedTab) {
//                        Text("A").tag(0)
//                        Text("B").tag(1)
//                    }
//                    .pickerStyle(.segmented)
//                    .padding()
//                    .background(.ultraThinMaterial)
//                }
//            }
//        }
//    }
//}
//
//import SwiftUI
//
//// MARK: - Height Probe (보이지 않게 높이 측정)
//struct HeightProbe<Content: View>: View {
//    let index: Int
//    let content: Content
//    @Binding var store: [Int: CGFloat]
//
//    init(index: Int, store: Binding<[Int: CGFloat]>, @ViewBuilder content: () -> Content) {
//        self.index = index
//        self._store = store
//        self.content = content()
//    }
//
//    var body: some View {
//        content
//            .background(
//                GeometryReader { geo in
//                    Color.clear
//                        .onAppear {
//                            store[index] = geo.size.height
//                        }
//                }
//            )
//            .hidden()
//    }
//}
//

//
//// MARK: - Main View
//struct SegmentView: View {
//
//    @State private var selectedTab = 0
//    @State private var heights: [Int: CGFloat] = [:]
//
//    private var maxHeight: CGFloat {
//        heights.values.max() ?? 1
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//
//            // 🔹 Segment Header
//            Picker("", selection: $selectedTab) {
//                Text("A").tag(0)
//                Text("B").tag(1)
//            }
//            .pickerStyle(.segmented)
//            .padding()
//            .background(.ultraThinMaterial)
//
//            // 🔹 실제 보여지는 페이지
//            TabView(selection: $selectedTab) {
//                AView()
//                    .tag(0)
//
//                BView()
//                    .tag(1)
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            .frame(height: maxHeight)
//            .animation(.easeInOut, value: maxHeight)
//
//            // 🔹 보이지 않는 측정용 뷰
//            ZStack {
//                HeightProbe(index: 0, store: $heights) {
//                    AView()
//                }
//
//                HeightProbe(index: 1, store: $heights) {
//                    BView()
//                }
//            }
//            .frame(height: 0)
//            .clipped()
//        }
//    }
//}
//
//
//// MARK: - A View
//struct AView: View {
//    var body: some View {
//        VStack(spacing: 12) {
//            ForEach(0..<3) { i in
//                Text("A View - Item \(i)")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color.blue.opacity(0.2))
//            }
//        }
//    }
//}
//
//// MARK: - B View
//struct BView: View {
//    var body: some View {
//        VStack(spacing: 12) {
//            ForEach(0..<10) { i in
//                Text("B View - Item \(i)")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color.green.opacity(0.2))
//            }
//        }
//    }
//}
//
//struct SegmentView: View {
//    @State private var selectedTab = 0
//
//    var body: some View {
//        ScrollView {
//            // MARK: - ImageExample
//            Rectangle()
//                .foregroundStyle(.blue)
//                .frame(maxWidth: .infinity)
//                .frame(height: 100)
//                
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//                
//                Section {
//                    VStack {
//                        Text("테스트 내용")
//                        Text("테스트 내용")
//                        Text("테스트 내용")
//                            
//                    }
//                } header: {
//                    HStack {
//                        Text("테스트 타이틀")
//                            .font(.system(size: 17, weight: .bold))
//                        Spacer()
//                    }
//                }
//
//                Section {
//                    Group {
//                        if selectedTab == 0 {
//                            AView()
//                        } else {
//                            BView()
//                        }
//                    }
//                } header: {
//                    Picker("", selection: $selectedTab) {
//                        Text("A").tag(0)
//                        Text("B").tag(1)
//                    }
//                    .pickerStyle(.segmented)
//                    .padding()
//                    .background(.ultraThinMaterial)
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//       
//    }
//}
//
//
//#Preview {
//    SegmentView()
//}




//// MARK: - A View
//struct AView: View {
//    var body: some View {
//        VStack(spacing: 12) {
//            ForEach(0..<3) { i in
//                Text("A View - Item \(i)")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color.blue.opacity(0.2))
//            }
//        }
//    }
//}
//
//// MARK: - B View
//struct BView: View {
//    var body: some View {
//        VStack(spacing: 12) {
//            ForEach(0..<10) { i in
//                Text("B View - Item \(i)")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color.green.opacity(0.2))
//            }
//        }
//    }
//}
//
//struct SegmentView: View {
//    @State private var selectedTab = 0
//
//    var body: some View {
//        ScrollView {
//            // MARK: - ImageExample
//            Rectangle()
//                .foregroundStyle(.blue)
//                .frame(maxWidth: .infinity)
//                .frame(height: 100)
//                
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//                
//                Section {
//                    VStack {
//                        Text("테스트 내용")
//                        Text("테스트 내용")
//                        Text("테스트 내용")
//                            
//                    }
//                } header: {
//                    HStack {
//                        Text("테스트 타이틀")
//                            .font(.system(size: 17, weight: .bold))
//                        Spacer()
//                    }
//                }
//
//                Section {
//                    Group {
//                        if selectedTab == 0 {
//                            AView()
//                        } else {
//                            BView()
//                        }
//                    }
//                } header: {
//                    Picker("", selection: $selectedTab) {
//                        Text("A").tag(0)
//                        Text("B").tag(1)
//                    }
//                    .pickerStyle(.segmented)
//                    .padding()
//                    .background(.ultraThinMaterial)
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//       
//    }
//}
//
//
//#Preview {
//    SegmentView()
//}
//
//import SwiftUI
//
//// MARK: - PopPang Style Segment
//struct PopPangSegment: View {
//    @Binding var selected: Int
//    let titles: [String]
//
//    var body: some View {
//        VStack(spacing: 6) {
//            HStack(spacing: 0) {
//                ForEach(titles.indices, id: \.self) { index in
//                    Button {
//                        withAnimation(.easeInOut) { selected = index }
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
//                ZStack(alignment: .leading) {
//                    Capsule().fill(.secondary.opacity(0.25)).frame(height: 3)
//                    Capsule()
//                        .fill(Color.primary)
//                        .frame(width: width, height: 3)
//                        .offset(x: CGFloat(selected) * width)
//                        .animation(.easeInOut, value: selected)
//                }
//            }
//            .frame(height: 3)
//        }
//    }
//}
//
//// MARK: - Example Views
//struct AView: View {
//    var body: some View {
//        VStack(spacing: 12) {
//            ForEach(0..<5) { i in
//                Text("A View - Item \(i)")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color.blue.opacity(0.15))
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//            }
//        }
//        .background(.yellow)
//    }
//}
//
//struct BView: View {
//    var body: some View {
//        VStack(spacing: 12) {
//            ForEach(0..<12) { i in
//                Text("B View - Item \(i)")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color.green.opacity(0.15))
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//            }
//        }
//    }
//}
//
//// MARK: - Paged Content (TabView 없이 슬라이드)
//struct PagedContent: View {
//    @Binding var selected: Int
//    let pageCount: Int
//    let swipeThreshold: CGFloat = 70
//
//    @GestureState private var dragX: CGFloat = 0
//    @State private var isHorizontalDragging = false
//
//    var body: some View {
//        GeometryReader { geo in
//            let width = geo.size.width
//            let spacing: CGFloat = 24
//
//            VStack(alignment: .leading, spacing: 0) {
//                HStack(alignment: .top, spacing: spacing) {
//                    AView()
//                        .frame(width: width)
//
//                    BView()
//                        .frame(width: width)
//                }
//                .offset(x: -CGFloat(selected) * (width + spacing) + dragX)
//                .animation(.easeInOut(duration: 0.25), value: selected)
//                .gesture(
//                    DragGesture(minimumDistance: 10)
//                        .updating($dragX) { value, state, _ in
//                            let dx = value.translation.width
//                            let dy = value.translation.height
//                            guard abs(dx) > abs(dy) else { return }
//                            state = dx
//                        }
//                        .onEnded { value in
//                            let dx = value.translation.width
//                            let dy = value.translation.height
//                            guard abs(dx) > abs(dy) else { return }
//
//                            if dx < -swipeThreshold {
//                                selected = min(selected + 1, pageCount - 1)
//                            } else if dx > swipeThreshold {
//                                selected = max(selected - 1, 0)
//                            }
//                        }
//                )
//
//                Spacer() // ⭐ 핵심: 아래로 밀지 않게 위 고정
//            }
//        }
//        .frame(height: 400) // ✅ 이 높이가 전체 영역
//        .scrollDisabled(isHorizontalDragging)
//    }
//}
//
//
//
//
//// MARK: - Main
//struct SegmentView: View {
//    @State private var selected = 0
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(height: 120)
//                    .overlay(
//                        Text("Header Area")
//                            .font(.title2.bold())
//                            .foregroundStyle(.white)
//                    )
//
//                Section {
//                    // ✅ 슬라이드 페이지
//                    PagedContent(selected: $selected, pageCount: 2)
//                        // ✅ 여기서 "콘텐츠 높이"를 주어야 세로 스크롤이 정상 계산됨
//                        //    (샘플은 BView가 더 길다고 가정)
//                        .frame(minHeight: 400) // 필요 시 조절/개선 가능
//
//                } header: {
//                    VStack(spacing: 0) {
//                        PopPangSegment(selected: $selected, titles: ["A", "B"])
//                            .padding(.horizontal, 20)
//                            .padding(.top, 8)
//                            .padding(.bottom, 6)
//
//                        Divider()
//                    }
//                    .background(.ultraThinMaterial)
//                }
//            }
//            
//            .padding(.horizontal, 20)
//        }
//    }
//}
//
//#Preview { SegmentView() }

//
//
//import SwiftUI
//
//// MARK: - Segment Header
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
//                ZStack(alignment: .leading) {
//                    Capsule().fill(.secondary.opacity(0.25)).frame(height: 3)
//                    Capsule()
//                        .fill(Color.primary)
//                        .frame(width: width, height: 3)
//                        .offset(x: CGFloat(selected) * width)
//                        .animation(.easeInOut, value: selected)
//                }
//            }
//            .frame(height: 3)
//        }
//    }
//}
//
//// MARK: - Example Pages
//struct AView: View {
//    var body: some View {
//        VStack(spacing: 12) {
//            ForEach(0..<5) { i in
//                Text("A View - Item \(i)")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color.blue.opacity(0.15))
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//            }
//        }
//        .background(.yellow)
//    }
//}
//
//struct BView: View {
//    var body: some View {
//        VStack(spacing: 22) {
//            ForEach(0..<12) { i in
//                Text("B View - Item \(i)")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color.green.opacity(0.15))
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//            }
//        }
//    }
//}
//
//// MARK: - Paged Content
//struct PagedContent: View {
//    @Binding var selected: Int
//    let views: [AnyView]
//
//    private let swipeThreshold: CGFloat = 70
//    @GestureState private var dragX: CGFloat = 0
//
//    var body: some View {
//        GeometryReader { geo in
//            let width = geo.size.width
//            let spacing: CGFloat = 24
//
//            VStack(alignment: .leading, spacing: 0) {
//                HStack(alignment: .top, spacing: spacing) {
//                    ForEach(views.indices, id: \.self) { index in
//                        views[index]
//                            .frame(width: width)
//                    }
//                }
//                .offset(x: -CGFloat(selected) * (width + spacing) + dragX)
//                .animation(.easeInOut(duration: 0.25), value: selected)
//
//                Spacer()
//            }
//            .contentShape(Rectangle()) // 전체 터치 영역
//            .simultaneousGesture( // ⭐ 핵심
//                DragGesture(minimumDistance: 10)
//                    .updating($dragX) { value, state, _ in
//                        if abs(value.translation.width) > abs(value.translation.height) {
//                            state = value.translation.width
//                        }
//                    }
//                    .onEnded { value in
//                        let dx = value.translation.width
//                        let dy = value.translation.height
//                        guard abs(dx) > abs(dy) else { return }
//
//                        if dx < -swipeThreshold {
//                            selected = min(selected + 1, views.count - 1)
//                        } else if dx > swipeThreshold {
//                            selected = max(selected - 1, 0)
//                        }
//                    }
//            )
//        }
//        // .frame(height: 400)
//    }
//}
//
//
//// MARK: - Main View
//struct SegmentView: View {
//    @State private var selected = 0
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(pinnedViews: [.sectionHeaders]) {
//
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(height: 120)
//                    .overlay(
//                        Text("Header Area")
//                            .font(.title2.bold())
//                            .foregroundStyle(.white)
//                    )
//
//                Section {
//                    PagedContent(
//                        selected: $selected,
//                        views: [
//                            AnyView(AView()),
//                            AnyView(BView()),
//                            AnyView(
//                                Text("C View")
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.orange.opacity(0.3))
//                            )
//                        ]
//                    )
//                } header: {
//                    VStack(spacing: 0) {
//                        PopPangSegment(
//                            selected: $selected,
//                            titles: ["A", "B", "C"]
//                        )
//                        .padding(.horizontal, 20)
//                        .padding(.top, 8)
//                        .padding(.bottom, 6)
//
//                        Divider()
//                    }
//                    .background(.ultraThinMaterial)
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//    }
//}
//
//#Preview {
//    SegmentView()
//}
//
//import SwiftUI
//
//// MARK: - Segment Header
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
//                ZStack(alignment: .leading) {
//                    Capsule().fill(.secondary.opacity(0.25)).frame(height: 3)
//                    Capsule()
//                        .fill(Color.primary)
//                        .frame(width: width, height: 3)
//                        .offset(x: CGFloat(selected) * width)
//                        .animation(.easeInOut, value: selected)
//                }
//            }
//            .frame(height: 3)
//        }
//    }
//}
//
//// MARK: - Page Views
//
//struct AView: View {
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 12) {
//                ForEach(0..<5) { i in
//                    cell("A View - Item \(i)", color: .blue)
//                }
//            }
//            .padding(.bottom, 30)
//        }
//    }
//}
//
//struct BView: View {
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 12) {
//                ForEach(0..<25) { i in
//                    cell("B View - Item \(i)", color: .green)
//                }
//            }
//            .padding(.bottom, 30)
//        }
//    }
//}
//
//struct CView: View {
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 12) {
//                ForEach(0..<8) { i in
//                    cell("C View - Item \(i)", color: .orange)
//                }
//            }
//            .padding(.bottom, 30)
//        }
//    }
//}
//
//// MARK: - Cell
//func cell(_ text: String, color: Color) -> some View {
//    Text(text)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding()
//        .background(color.opacity(0.15))
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//}
//
//// MARK: - Pager
//struct PagedContent: View {
//    @Binding var selected: Int
//    let pages: [AnyView]
//
//    @GestureState private var dragX: CGFloat = 0
//    private let swipeThreshold: CGFloat = 70
//
//    var body: some View {
//        GeometryReader { geo in
//            let width = geo.size.width
//
//            HStack(spacing: 0) {
//                ForEach(pages.indices, id: \.self) { i in
//                    pages[i]
//                        .frame(width: width)
//                }
//            }
//            .offset(x: -CGFloat(selected) * width + dragX)
//            .animation(.easeInOut, value: selected)
//            .gesture(
//                DragGesture()
//                    .updating($dragX) { value, state, _ in
//                        if abs(value.translation.width) > abs(value.translation.height) {
//                            state = value.translation.width
//                        }
//                    }
//                    .onEnded { value in
//                        let dx = value.translation.width
//                        if dx < -swipeThreshold {
//                            selected = min(selected + 1, pages.count - 1)
//                        } else if dx > swipeThreshold {
//                            selected = max(selected - 1, 0)
//                        }
//                    }
//            )
//        }
//    }
//}
//
//// MARK: - Main View
//struct SegmentView: View {
//    @State private var selected = 0
//
//    var body: some View {
//        VStack(spacing: 0) {
//
//            // Header
//            Rectangle()
//                .fill(Color.blue)
//                .frame(height: 120)
//                .overlay(
//                    Text("Header Area")
//                        .font(.title2.bold())
//                        .foregroundStyle(.white)
//                )
//
//            // Segment
//            PopPangSegment(
//                selected: $selected,
//                titles: ["A", "B", "C"]
//            )
//            .padding(.horizontal, 20)
//            .padding(.vertical, 6)
//            .background(.ultraThinMaterial)
//
//            // Pages
//            PagedContent(
//                selected: $selected,
//                pages: [
//                    AnyView(AView()),
//                    AnyView(BView()),
//                    AnyView(CView())
//                ]
//            )
//        }
//        .ignoresSafeArea(edges: .bottom)
//    }
//}
//
//#Preview {
//    SegmentView()
//}



struct SegmentView: View {
    @State private var isChildScrollEnabled = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                Text("부모 스크롤 영역")
                    .font(.title)

                Button("자식 스크롤 활성화") {
                    isChildScrollEnabled = true
                }

                ChildScrollView(isEnabled: isChildScrollEnabled)
                    .frame(height: 300)
            }
            .padding()
        }
        .scrollDisabled(isChildScrollEnabled) // 👈 핵심
    }
}

struct ChildScrollView: View {
    let isEnabled: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<30) { i in
                    Text("자식 아이템 \(i)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .scrollDisabled(!isEnabled) // 👈 반대 조건
    }
}
#Preview {
    SegmentView()
}
