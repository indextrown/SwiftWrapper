//
//  ReuseIdentifiable.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/17/25.
//

import Foundation

// reuseIdentifier를 편리하게 만들어주는 기능
protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
