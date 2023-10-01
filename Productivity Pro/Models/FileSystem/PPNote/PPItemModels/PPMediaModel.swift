//
//  PPMediaModel.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 01.10.23.
//

import SwiftUI
import SwiftData

@Model final class PPMediaModel {
    init(media: Data) {
        self.strokeStyle = .line
        self.media = media
    }
    
    var media: Data
    
    var stroke: Bool = false
    var strokeColor: Data = Color.accentColor.toCodable()
    var strokeWidth: CGFloat = 5
    var strokeStyle: PPStrokeStyle
    
    var cornerRadius: CGFloat = 0
    var rotation: CGFloat = 0
}

