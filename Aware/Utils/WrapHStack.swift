//
//  WrapHStack.swift
//  HeadphonesAware
//
//  Created by Shamam Alkafri on 23/05/2025.
//

import SwiftUI

struct WrapHStack<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let content: (Data.Element) -> Content

    init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ForEach(Array(data.prefix(3)), id: \.self) { item in
                    content(item)
                }
            }
        }
    }
}
