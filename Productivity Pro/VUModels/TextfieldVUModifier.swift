//
//  TextfieldVUModifier.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 27.02.24.
//

import SwiftUI

struct TextfieldVUModifier: ViewModifier {
    @Bindable var vuModel: TextfieldVUModel
    @Bindable var item: PPItemModel

    func body(content: Content) -> some View {
        content
            .onAppear {
                vuModel.setModel(from: item)
            }
            .onChange(of: item.x) {
                vuModel.position.x = item.x
            }
            .onChange(of: item.y) {
                vuModel.position.y = item.y
            }
            .onChange(of: item.width) {
                vuModel.size.width = item.width
            }
            .onChange(of: item.height) {
                vuModel.size.height = item.height
            }
    }
}

