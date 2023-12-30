//
//  ExportableTextFieldModel.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 04.10.23.
//

import Foundation

public struct ExportableTextFieldModel: Codable {
    var string: String
    var textColor: Data
    
    var fontName: String
    var fontSize: Double
    
    var fill: Bool
    var fillColor: Data
    
    var stroke: Bool = false
    var strokeColor: Data
    var strokeWidth: Double
    var strokeStyle: PPStrokeType.RawValue
    
    var shadow: Bool
    var shadowColor: Data
    
    var cornerRadius: Double
    var rotation: Double = 0
}
