//
//  SwiftUIView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 18.07.23.
//

import SwiftUI

enum PPDrawingTool: String, Codable {
    case pen = "pen"
    case highlighter = "highlighter"
    case eraser = "eraser"
    case lasso = "lasso"
    case magicwand = "magicwand"
}

enum PPEraserType: String, Codable {
    case pixel = "pixel"
    case point = "point"
}
