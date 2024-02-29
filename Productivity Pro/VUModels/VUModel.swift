//
//  VUModel.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 27.02.24.
//

import SwiftUI

@Observable final class VUModel {
    var position: CGPoint = .zero
    var size: CGSize = .zero

    func setModel(from item: PPItemModel) {
        self.position = CGPoint(x: item.x, y: item.y)
        self.size = CGSize(width: item.width, height: item.height)
    }
}